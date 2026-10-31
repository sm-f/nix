pack("https://github.com/stevearc/conform.nvim")
require("conform").setup({
    formatters_by_ft = {
        css = { "prettier" },
        go = { "gofmt" },
        html = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        mdx = { "prettier" },
        nix = { "nixfmt" },
        python = { "ruff_organize_imports", "ruff_format" },
        rust = { "rustfmt" },
        scss = { "prettier" },
        sh = { "shfmt" },
        templ = { "templ" },
        toml = { "taplo" },
        yaml = { "prettier" },
    },

    format_after_save = function()
        --- @diagnostic disable-next-line: unnecessary-if
        if not vim.g.autoformat then
            return
        else
            if vim.bo.filetype == "ps1" then
                vim.lsp.buf.format()
                return
            end
            ---@diagnostic disable-next-line: return-type-mismatch
            return { lsp_format = "fallback", async = true }
        end
    end,
})
