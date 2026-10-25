--- @type vim.lsp.Config
return {
    cmd = { "csharp-ls" },
    filetypes = { "cs" },
    root_dir = function(bufnr, on_dir)
        -- prefer solution root, fall back to project root
        local root = vim.fs.root(bufnr, function(name, _)
            return name:match("%.sln$") ~= nil or name:match("%.slnx$") ~= nil
        end)
        root = root
            or vim.fs.root(bufnr, function(name, _)
                return name:match("%.csproj$") ~= nil
            end)
        if root then
            on_dir(root)
        end
    end,
}
