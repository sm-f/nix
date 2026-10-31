--- Add vim.pack plugins with project defaults.
---@param ... string|vim.pack.Spec
function _G.pack(...)
    vim.pack.add({ ... }, { confirm = false, load = true })
end

require("plugins.colourscheme")
require("plugins.mini")
require("plugins.snacks")
require("plugins.lspconfig")
require("plugins.treesitter")
require("plugins.blinkcmp")
require("plugins.gitsigns")
require("plugins.conform")
require("plugins.noice")
require("plugins.which-key")
require("plugins.hop")
require("plugins.grug-far")
require("plugins.todo-comments")
require("plugins.render-markdown")
require("plugins.resession")
require("plugins.obsidian")
