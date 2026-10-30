local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General Settings
local general = augroup("General Settings", { clear = true })
local using_stdin = false

autocmd("FileType", {
    group = general,
    pattern = {
        "grug-far",
        "help",
        "checkhealth",
        "copilot-chat",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", {
            buffer = event.buf,
            silent = true,
            desc = "Quit buffer",
        })
    end,
})

autocmd("VimEnter", {
    group = general,
    callback = function()
        if vim.fn.argc(-1) == 0 and not using_stdin then
            require("resession").load(vim.fn.getcwd(), { silence_errors = true })
        end
    end,
    nested = true,
    desc = "Load previous session from cwd, if no args were given",
})

autocmd("VimLeavePre", {
    group = general,
    callback = function()
        require("resession").save(vim.fn.getcwd(), { notify = true })
    end,
    desc = "Save session to cwd on exit",
})

autocmd("StdinReadPre", {
    callback = function()
        using_stdin = true
    end,
})
