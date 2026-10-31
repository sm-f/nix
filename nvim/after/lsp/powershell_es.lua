---@type vim.lsp.Config
return {
    cmd = {
        "powershell-editor-services",
        "-Stdio",
        "-LogLevel",
        "Warning",
        "-SessionDetailsPath",
        vim.fn.stdpath("cache") .. "/powershell_es.session.json",
    },
    filetypes = { "ps1", "psm1" },
    init_options = { enableProfileLoading = false },
    settings = { powershell = { codeFormatting = { Preset = "Stroustrup" } } },
}
