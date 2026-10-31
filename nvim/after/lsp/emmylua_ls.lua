-- emmylua_ls: expose Neovim runtime + all installed plugins as workspace library.
local library = vim.api.nvim_get_runtime_file("", true)
local lazy_root = vim.fn.stdpath("data") .. "/lazy"
if vim.fn.isdirectory(lazy_root) == 1 then
    for _, plugin in ipairs(vim.fn.readdir(lazy_root)) do
        library[#library + 1] = lazy_root .. "/" .. plugin
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
