print("hello from init.lua")
require("bryce")
vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.termguicolors = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes"
vim.opt.hidden = true

vim.g.mapleader = ' ' 
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true })

-- map ctrl p to find files with telescope
vim.api.nvim_set_keymap('n', '<C-p>', ':Telescope find_files<CR>', { noremap = true })
