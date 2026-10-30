return {
    "nvim-treesitter/nvim-treesitter",
    build = function()
        local TS = require("nvim-treesitter")
        TS.update(nil, { summary = true })
    end,
    lazy = false,
    config = function()
        local TS = require("nvim-treesitter")

        local group = vim.api.nvim_create_augroup("Treesitter", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            callback = function(event)
                pcall(vim.treesitter.start, event.buf)
            end,
            desc = "Start treesitter automatically",
        })
        local ensure_installed = {
            "bash",
            "bicep",
            "c_sharp",
            "css",
            "gitignore",
            "go",
            "gomod",
            "gosum",
            "gowork",
            "html",
            "http",
            "json",
            "just",
            "kdl",
            "lua",
            "luadoc",
            "luap",
            "markdown",
            "markdown_inline",
            "nix",
            "odin",
            "powershell",
            "python",
            "razor",
            "regex",
            "ron",
            "rust",
            "sql",
            "templ",
            "toml",
            "typescript",
            "vim",
            "vimdoc",
            "yaml",
        }

        vim.treesitter.language.register("markdown", "mdx")
        local installed = TS.get_installed()
        local to_install = vim.tbl_filter(function(lang)
            return not vim.tbl_contains(installed, lang)
        end, ensure_installed or {})

        if #to_install > 0 then
            vim.schedule(function()
                TS.install(to_install, { summary = true })
            end)
        end
    end,
}
