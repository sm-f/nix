vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = true,
    virtual_text = {
        source = "if_many",
        prefix = "●",
    },
})

-- enable all lsp definitions in nvim/lsp
local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
local servers = {}
local handle = vim.uv.fs_scandir(lsp_dir)
if handle then
    while true do
        local name, type = vim.uv.fs_scandir_next(handle)
        if not name then
            break
        end
        if type == "file" and name:match("%.lua$") then
            servers[#servers + 1] = name:gsub("%.lua$", "")
        end
    end
end
vim.lsp.enable(servers)
