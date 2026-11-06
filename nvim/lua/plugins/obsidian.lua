---@diagnostic disable: missing-fields, assign-type-mismatch
local map = require("utils").map
local obsidian_path = os.getenv("OBSIDIAN_PATH")
if obsidian_path == nil then
    return
end

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

map("n", "<leader>od", "<cmd>Obsidian today<cr>", { desc = "Daily note" })
map("n", "<leader>oy", "<cmd>Obsidian yesterday<cr>", { desc = "Yesterday's note" })
map("n", "<leader>ot", "<cmd>Obsidian tomorrow<cr>", { desc = "Tomorrow's note" })
map("n", "<leader>on", "<cmd>Obsidian new_from_template Core<cr>", { desc = "New Obsidian note" })
map("n", "<leader>os", "<cmd>Obsidian search<cr>", { desc = "Search Obsidian notes" })
map("n", "<leader>oo", "<cmd>Obsidian quick_switch<cr>", { desc = "Quick Switch" })
map("n", "<leader>of", "<cmd>Obsidian follow_link<cr>", { desc = "Follow link under cursor" })
map("n", "<leader>op", "<cmd>Obsidian paste_img<cr>", { desc = "Paste image from clipboard" })
