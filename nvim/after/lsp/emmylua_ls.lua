-- emmylua_ls: expose Neovim runtime + all installed plugins as workspace library.
local library = vim.api.nvim_get_runtime_file("", true)
local ok, plugins = pcall(vim.pack.get)
if ok then
    for _, plugin in ipairs(plugins) do
        library[#library + 1] = plugin.path
    end
end

---@type vim.lsp.Config
return {
    settings = {
        emmylua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = library },
        },
    },
}
