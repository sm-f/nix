---@diagnostic disable: missing-fields, assign-type-mismatch
pack("https://github.com/obsidian-nvim/obsidian.nvim")
require("obsidian").setup({
    attachments = { folder = "attachments", confirm_img_paste = false },
    frontmatter = { enabled = false },
    new_notes_location = "notes_subdir",
    notes_subdir = "Zettelkasten",
    picker = { snacks = true },
    templates = { folder = "Templates", date_format = "%Y-%m-%d", time_format = "%H:%M" },
    daily_notes = { folder = "Daily", date_format = "%Y-%m-%d-%A", template = "Daily", default_tags = { "daily" } },
    ui = { enable = false },
    workspaces = { { name = "vault", path = os.getenv("OBSIDIAN_PATH") } },

    note_id_func = function(title)
        if title ~= nil then
            return title
        else
            return vim.fn.input("Note title: ") or tostring(os.date("%Y%m%d%H%M"))
        end
    end,

    -- TODO: remove when the warning about legacy commands is gone
    legacy_commands = false,
})

vim.keymap.set("n", "<leader>od", "<cmd>Obsidian today<cr>", { desc = "Daily note" })
vim.keymap.set("n", "<leader>oy", "<cmd>Obsidian yesterday<cr>", { desc = "Daily note" })
vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian tomorrow<cr>", { desc = "Apply Core Template" })
vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new_from_template Core<cr>", { desc = "New Obsidian note" })
vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<cr>", { desc = "Search Obsidian notes" })
vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian quick_switch<cr>", { desc = "Quick Switch" })
vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "Show location list of backlinks" })
vim.keymap.set("n", "<leader>of", "<cmd>Obsidian follow_link<cr>", { desc = "Follow link under cursor" })
vim.keymap.set("n", "<leader>op", "<cmd>Obsidian paste_img<cr>", { desc = "Paste image from clipboard" })
