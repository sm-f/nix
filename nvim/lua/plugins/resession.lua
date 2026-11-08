---@diagnostic disable: assign-type-mismatch, missing-fields
pack("https://github.com/stevearc/resession.nvim", "https://github.com/scottmckendry/pick-resession.nvim")
require("resession").setup({
    autosave = {
        enabled = true,
        interval = 60,
        notify = false,
    },
})

require("pick-resession").setup({
    path_icons = {
        { match = "/home/" .. vim.g.user .. "/git/", icon = " ", highlight = "Changed" },
        { match = "/home/" .. vim.g.user .. "/", icon = " ", highlight = "Special" },
    },
})
