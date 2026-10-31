pack("https://github.com/MeanderingProgrammer/render-markdown.nvim")
require("render-markdown").setup({
    bullet = { left_pad = 0, right_pad = 1 },
    code = { width = "block", left_pad = 2, right_pad = 2 },
    completions = { lsp = { enabled = true } },
    heading = { width = "block", left_pad = 1, right_pad = 1, position = "inline" },
    pipe_table = { border = { "╭", "┬", "╮", "├", "┼", "┤", "╰", "┴", "╯", "│", "─" } },
    sign = { enabled = false },
})
