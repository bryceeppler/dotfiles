print("hello from remap")
-- map ctrl p to find files with telescope
vim.api.nvim_set_keymap('n', '<C-p>', ':Telescope find_files<CR>', { noremap = true })
