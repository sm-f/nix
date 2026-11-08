local M = {}

--- Switch to the previous buffer
function M.switch_to_other_buffer()
    -- try alternate buffer first
    local ok, _ = pcall(function()
        vim.cmd("buffer #")
    end)
    if ok then
        return
    end

    -- fallback to previous buffer
    if M.get_buffer_count() > 1 then
        vim.cmd("bprevious")
        return
    end

    vim.notify("No other buffer to switch to!", 3, { title = "Warning" })
end

--- Get the number of open buffers
--- @return number
function M.get_buffer_count()
    local count = 0
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buflisted and vim.bo[buf].buftype ~= "nofile" then
            count = count + 1
        end
    end
    return count
end

function M.toggle_global_boolean(option, description)
    return require("snacks").toggle({
        name = description,
        get = function()
            return vim.g[option] == nil or vim.g[option]
        end,
        set = function(state)
            vim.g[option] = state
        end,
    })
end

--- Returns a snacks toggle for copilot completion
--- @return snacks.toggle.Class
function M.copilot_toggle()
    return require("snacks").toggle({
        name = "Copilot Completion",
        get = function()
            return vim.lsp.inline_completion.is_enabled({ bufnr = 0 })
        end,
        set = function(state)
            vim.lsp.inline_completion.enable(state, { bufnr = 0 })
        end,
    })
end

--- Restart all LSP clients attached to the current buffer
function M.restart_lsp()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        vim.notify("No LSP client attached to current buffer", vim.log.levels.WARN)
        return
    end
    for _, client in ipairs(clients) do
        local config = client.config
        local name = client.name
        vim.lsp.client.stop(client, true)
        vim.defer_fn(function()
            vim.lsp.start(config)
            vim.notify("LSP restarted: " .. name, vim.log.levels.INFO)
        end, 50)
    end
end

--- Open the LSP log file in a read-only split
function M.open_lsp_log()
    local log_path = vim.lsp.log.get_filename()
    if vim.fn.filereadable(log_path) == 0 then
        vim.notify("LSP log file not found: " .. log_path, vim.log.levels.WARN)
        return
    end
    vim.cmd("e " .. log_path)
    vim.notify("Opened LSP log: " .. log_path, vim.log.levels.INFO)
end

--- Open GitHub markdown preview for the current buffer
function M.gh_markdown_preview()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname == "" then
        vim.notify("No file to preview", vim.log.levels.WARN)
        return
    end
    vim.fn.jobstart({ "gh", "markdown-preview", bufname }, {
        on_stderr = function(_, data)
            if not data then
                return
            end
            --- remove the last line if it's empty
            if data[#data] == "" then
                table.remove(data, #data)
            end
            vim.notify(table.concat(data, "\n"), vim.log.levels.INFO, { title = "Markdown Preview" })
        end,
    })
end

--- Map a key combination to a command
---@param modes string|string[]: The modes to map the key combination to
---@param lhs string|string[]: The key combinations to map
---@param rhs string|function: The command to run when the key combination is pressed
---@param opts? table: Options to pass to the keymap
function M.map(modes, lhs, rhs, opts)
    local options = vim.tbl_extend("force", { silent = true }, opts or {})
    if type(modes) == "string" then
        modes = { modes }
    end
    if type(lhs) == "string" then
        lhs = { lhs }
    end
    for _, mode in ipairs(modes) do
        for _, key in ipairs(lhs) do
            vim.keymap.set(mode, key, rhs, options)
        end
    end
end

return M
