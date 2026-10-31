---@diagnostic disable: missing-fields, param-type-mismatch
pack("https://github.com/MunifTanjim/nui.nvim")
pack("https://github.com/folke/noice.nvim")
require("noice").setup({
    presets = { bottom_search = true, lsp_doc_border = true },
    cmdline = { view = "cmdline" },
    views = { mini = { win_options = { winblend = 0 } } },
})
