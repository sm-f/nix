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
    if vim.lsp.config[name] then
        enabled[#enabled + 1] = name
    else
        vim.notify(("[lsp] no config for %q, is nvim-lspconfig installed?"):format(name), vim.log.levels.WARN)
    end
end

vim.lsp.enable(enabled)
