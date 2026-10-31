pack("https://github.com/scottmckendry/cyberdream.nvim")
require("cyberdream").setup({
    variant = "muted",
    transparent = true,
    italic_comments = true,
    hide_fillchars = true,
    terminal_colors = false,
    cache = true,
    borderless_pickers = true,
    overrides = function(c)
        return {
            CursorLine = { bg = c.bg },
            CursorLineNr = { fg = c.magenta },
        }
    end,
})
