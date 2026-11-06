pack("https://github.com/lewis6991/gitsigns.nvim")
local map = require("utils").map
require("gitsigns").setup({
    signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
    },
    current_line_blame = true,
    on_attach = function(buffer)
        map("n", "<leader>ghs", ":Gitsigns stage_hunk<CR>", { buffer = buffer, desc = "stage Hunk" })
        map("n", "<leader>ghr", ":Gitsigns reset_hunk<CR>", { buffer = buffer, desc = "Reset Hunk" })
        map("n", "<leader>ghS", ":Gitsigns stage_buffer<CR>", { buffer = buffer, desc = "Stage Buffer" })
        map("n", "<leader>ghu", ":Gitsigns undo_stage_hunk<CR>", { buffer = buffer, desc = "Undo Stage Hunk" })
        map("n", "<leader>ghR", ":Gitsigns reset_buffer<CR>", { buffer = buffer, desc = "Reset Buffer" })
    end,
})
