vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = true,
    virtual_text = {
        source = "if_many",
        prefix = "●",
    },
})

local servers = {
    "basedpyright",
    "bashls",
    "bicep",
    "clangd",
    "copilot",
    "csharp_ls",
    "emmylua_ls",
    "gopls",
    "html",
    "jsonls",
    "nixd",
    "ols",
    "powershell_es",
    "rust_analyzer",
    "tailwindcss",
    "taplo",
    "templ",
    "ts_ls",
    "yamlls",
}

local enabled = {}
for _, name in ipairs(servers) do
    enabled[#enabled + 1] = name
end

vim.lsp.enable(enabled)
vim.lsp.inline_completion.enable(true)
