--- @type vim.lsp.Config
return {
    cmd = { "Bicep.LangServer", "--stdio" },
    filetypes = { "bicep", "bicep-params" },
    root_markers = { ".git" },
    init_options = {},
}
