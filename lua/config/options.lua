vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt
opt.autowrite = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.number = true
opt.relativenumber = false
opt.wrap = true
opt.linebreak = true
-- Over SSH, leave the clipboard empty so Neovim falls back to OSC 52
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
opt.mouse = "a"
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 4
opt.splitright = true
opt.splitbelow = true
opt.undofile = true
opt.confirm = true
opt.updatetime = 200
opt.timeoutlen = 300
opt.laststatus = 3
opt.showmode = false

vim.diagnostic.config({ virtual_text = true, severity_sort = true })
