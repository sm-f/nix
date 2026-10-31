---@diagnostic disable: param-type-mismatch, missing-fields
pack("https://github.com/rafamadriz/friendly-snippets")
pack({ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") })
require("blink.cmp").setup({
    cmdline = { completion = { menu = { auto_show = true } } },
    completion = {
        menu = {
            scrollbar = false,
            auto_show = true,
            border = { { "󱐋", "WarningMsg" }, "─", "╮", "│", "╯", "─", "╰", "│" },
        },
        documentation = {
            auto_show = true,
            window = {
                border = { { "", "DiagnosticHint" }, "─", "╮", "│", "╯", "─", "╰", "│" },
            },
        },
    },
})
