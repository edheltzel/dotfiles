local key = vim.keymap

-- leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- core commands
key.set('n','<leader>fs', ':update<CR>')
key.set('n','<leader>qq', ':quitall<CR>')
key.set('n','<leader>so', ':source<CR>')
key.set("i", "jk", "<Esc>", { desc = "Exit insert mode with jj" })
-- center screen during jumps
key.set('n','<C-d>', '<C-d>zz', {desc = 'stay centered when scrolling down'})
key.set('n','<C-u>', '<C-u>zz', {desc = 'stay centered when scrolling up'})
key.set('n','N', 'Nzzzv', {desc = 'stay centered next search result'})
key.set('n','n', 'nzzzv', {desc = 'stay centered prev search result'})

-- buffer nav
key.set('n', '<leader>bn', ':bnext<CR>', { desc = 'Next buffer' })
key.set('n', '<leader>bp', ':bprevious<CR>', { desc = 'Previous buffer' })
key.set('n', '<leader>bd', ':bdelete<CR>', { desc = 'Close buffer' })
key.set('n', '<leader>bb', ':buffers<CR>', {desc = 'List open buffers'})

-- splits and resize
vim.keymap.set('n', '<leader>bl', ':vsplit<CR>', { noremap = true, silent = true, desc = "Create buffer split on right"})
vim.keymap.set('n', '<leader>bh', ':leftabove vsplit<CR>', { noremap = true, silent = true, desc = "Create buffer split on left" })
vim.keymap.set('n', '<leader>bk', ':split<CR>', { noremap = true, silent = true, desc = "Create buffer split on top" })
vim.keymap.set('n', '<leader>bj', ':belowright split<CR>', { noremap = true, silent = true, desc = "Create buffer split on bottom" })

-- editing
key.set('n','Y','y$', {desc = 'Yank to the end of the line'})

--wrap selected text with quotes
-- key.set('v', '<leader>(', 'c()<Esc>P', { noremap = true, desc = 'Wrap in parentheses' })
-- key.set('v', '<leader>{', 'c{}<Esc>P', { noremap = true, desc = 'Wrap in curly braces' })
-- key.set('v', '<leader>[', 'c[]<Esc>P', { noremap = true, desc = 'Wrap in square brackets' })
