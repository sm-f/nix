vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.autoformat = true
vim.g.user = os.getenv("USERNAME") or os.getenv("USER")

local opt = vim.opt
opt.shell = "zsh"

-- UI/General
opt.number = true
opt.relativenumber = true
opt.ignorecase = true
opt.cursorline = true
opt.clipboard = "unnamedplus"
opt.termguicolors = true
opt.confirm = true
opt.mouse = "a"
opt.undofile = true
opt.swapfile = false
opt.conceallevel = 1
opt.scrolloff = 12
opt.wrap = true
opt.linebreak = true
opt.spelllang = "en_nz"
opt.spell = true
opt.showtabline = 0
opt.title = true
opt.titlestring = "%{fnamemodify(getcwd(), ':t')} - %t"

-- Set statusline
opt.laststatus = 3
opt.statusline = require("statusline").statusline

-- Set tab width
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.breakindent = true
opt.breakindentopt = "shift:2"
opt.showbreak = "↳"

-- Make cursor blink
opt.guicursor = {
    "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50",
    "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
    "sm:block-blinkwait175-blinkoff150-blinkon175",
}
