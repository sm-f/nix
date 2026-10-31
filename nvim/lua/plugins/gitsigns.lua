pack("https://github.com/lewis6991/gitsigns.nvim")
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
        local function map(l, r, desc)
            vim.keymap.set("n", l, r, { buffer = buffer, desc = desc })
        end

        map("]h", ":Gitsigns next_hunk<CR>", "Next Hunk")
        map("[h", ":Gitsigns prev_hunk<CR>", "Prev Hunk")
        map("<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map("<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("<leader>ghS", ":Gitsigns stage_buffer<CR>", "Stage Buffer")
        map("<leader>ghu", ":Gitsigns undo_stage_hunk<CR>", "Undo Stage Hunk")
        map("<leader>ghR", ":Gitsigns reset_buffer<CR>", "Reset Buffer")
    end,
})
