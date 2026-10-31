pack("https://github.com/nvim-mini/mini.icons")
pack("https://github.com/nvim-mini/mini.pairs")
pack("https://github.com/nvim-mini/mini.indentscope")
pack("https://github.com/nvim-mini/mini.hipatterns")
pack("https://github.com/nvim-mini/mini.files")

require("mini.pairs").setup({
    modes = { insert = true, command = true, terminal = false },
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
    skip_ts = { "string" },
    skip_unbalanced = true,
    markdown = true,
})

require("mini.indentscope").setup({
    symbol = "│",
    options = { try_as_border = true },
})

local function mini_indentscope_disable()
    vim.api.nvim_create_autocmd("FileType", {
        pattern = {
            "Trouble",
            "alpha",
            "copilot-chat",
            "help",
            "lazy",
            "neotree",
            "notify",
            "snacks_terminal",
        },
        callback = function()
            vim.b.miniindentscope_disable = true
        end,
    })
end

mini_indentscope_disable()

local hipatterns = require("mini.hipatterns")
hipatterns.setup({
    highlighters = {
        hex_color = hipatterns.gen_highlighter.hex_color(),
    },
})

require("mini.files").setup()

vim.keymap.set("n", "<leader>ee", function()
    local path = vim.bo.buftype ~= "nofile" and vim.api.nvim_buf_get_name(0) or nil
    local ok = pcall(require("mini.files").open, path)
    if not ok then
        require("mini.files").open()
    end
end, { desc = "Open mini.files (cwd)" })

local function mini_files_config()
    local MiniFiles = require("mini.files")
    local ns = vim.api.nvim_create_namespace("mini_files_git")
    ---@type table<string, { paths: table<string, any>, dirs: table<string, any> }|false|nil>
    local cache = {} -- root -> status data; false while git runs

    -- { symbol, highlight group, rank (used for directory aggregation) }
    local statuses = {
        [" M"] = { "", "MiniDepsHint", 4 },
        ["M "] = { "", "MiniDiffSignAdd", 4 },
        ["MM"] = { "", "MiniDiffSignChange", 4 },
        ["A "] = { "", "MiniDiffSignAdd", 4 },
        ["AA"] = { "≈", "MiniDiffSignAdd", 6 },
        ["D "] = { "-", "MiniDiffSignDelete", 5 },
        ["AM"] = { "⊕", "MiniDiffSignChange", 4 },
        ["AD"] = { "-•", "MiniDiffSignChange", 5 },
        ["R "] = { "→", "MiniDiffSignChange", 4 },
        ["U "] = { "‖", "MiniDiffSignChange", 6 },
        ["UU"] = { "⇄", "MiniDiffSignAdd", 6 },
        ["UA"] = { "⊕", "MiniDiffSignAdd", 6 },
        ["??"] = { "", "MiniDepsPlaceholder", 3 },
        ["!!"] = { "", "MiniIconsAzure", 1 },
    }
    local unknown = { "?", "NonText", 2 }

    local function root_of(buf)
        local path = vim.api.nvim_buf_get_name(buf):match("^minifiles://%d+/(.*)$")
        local root = path and vim.fs.root(path, ".git")
        return root and vim.fs.normalize(root) or nil
    end

    local function parse(root, out)
        local data = { paths = {}, dirs = {} }
        local items = vim.split(out, "\0", { plain = true, trimempty = true })
        local i = 1
        while i <= #items do
            ---@diagnostic disable-next-line: need-check-nil, param-type-mismatch
            local xy, path = items[i]:sub(1, 2), items[i]:sub(4)
            -- A `-z` rename/copy stores its source path in the next item.
            i = i + (xy:find("[RC]") and 2 or 1)
            local info = statuses[xy] or unknown
            local abs = vim.fs.normalize(root .. "/" .. path:gsub("/$", ""))
            data.paths[abs] = info
            if xy ~= "!!" then
                local dir = abs:match("^(.*)/[^/]+$")
                while dir and dir ~= root do
                    if not data.dirs[dir] or info[3] > data.dirs[dir][3] then
                        data.dirs[dir] = info
                    end
                    dir = dir:match("^(.*)/[^/]+$")
                end
            end
        end
        return data
    end

    local function render(buf)
        local root = root_of(buf)
        vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
        if not root or not cache[root] then
            return
        end
        for lnum = 1, vim.api.nvim_buf_line_count(buf) do
            local entry = MiniFiles.get_fs_entry(buf, lnum)
            if entry then
                local path = vim.fs.normalize(entry.path)
                local info = cache[root].paths[path] or (entry.fs_type == "directory" and cache[root].dirs[path])
                if info then
                    local symbol, hl = info[1], info[2]
                    if vim.fn.strdisplaywidth(symbol) <= 2 then
                        vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, 0, {
                            sign_text = symbol,
                            sign_hl_group = hl,
                            priority = 2,
                        })
                    end
                    local line = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1]
                    local col = line and line:find(entry.name, 1, true)
                    if col then
                        vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, col - 1, {
                            end_col = col - 1 + #entry.name,
                            hl_group = hl,
                            priority = 1,
                        })
                    end
                end
            end
        end
    end

    local function update(buf)
        local root = root_of(buf)
        if not root then
            return
        end
        if cache[root] ~= nil then
            return cache[root] and render(buf)
        end
        cache[root] = false
        vim.system({ "git", "status", "--porcelain=v1", "-z", "--ignored" }, { cwd = root, text = true }, function(out)
            vim.schedule(function()
                cache[root] = out.code == 0 and parse(root, out.stdout) or nil
                if not cache[root] then
                    return
                end
                for _, b in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.api.nvim_buf_is_valid(b) and root_of(b) == root then
                        render(b)
                    end
                end
            end)
        end)
    end

    local au = vim.api.nvim_create_augroup("MiniFilesGit", { clear = true })
    vim.api.nvim_create_autocmd("User", {
        group = au,
        pattern = { "MiniFilesExplorerOpen", "MiniFilesBufferUpdate" },
        callback = function(args)
            update((args.data and args.data.buf_id) or vim.api.nvim_get_current_buf())
        end,
    })
    vim.api.nvim_create_autocmd("User", {
        group = au,
        pattern = { "MiniFilesExplorerClose", "MiniFilesAction*" },
        callback = function()
            cache = {}
        end,
    })
end

mini_files_config()
