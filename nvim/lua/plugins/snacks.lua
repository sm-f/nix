pack("https://github.com/folke/snacks.nvim")
require("mini.icons").setup()
require("mini.icons").mock_nvim_web_devicons()
require("snacks").setup({
    image = { doc = { enabled = true, max_height = vim.o.lines * 0.5, max_width = vim.o.columns * 0.5 } },
    notifier = { enabled = true },
    picker = { prompt = "   ", formatters = { file = { filename_first = true } } },
    terminal = { win = { position = "right", width = 0.5, wo = { winbar = "" } } },
    words = { enabled = true },
})
