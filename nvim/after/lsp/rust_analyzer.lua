---@type vim.lsp.Config
return {
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = { command = "clippy" },
            cargo = { loadOutDirsFromCheck = true },
        },
    },
}
