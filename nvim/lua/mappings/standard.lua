vim.keymap.set({ 'i', 'n', 'v', 'x', 'c' }, 'dv', '<Esc>')
vim.keymap.set('', '<leader>h', '<cmd>noh<cr>')

-- Better Up/Down
vim.keymap.set({ 'n' }, '<C-u>', '10kzz')
vim.keymap.set({ 'n' }, '<C-d>', '10jzz')

-- Quickfix list
vim.keymap.set('', '<leader>cn', '<cmd>cnext<cr>')
vim.keymap.set('', '<leader>cp', '<cmd>cprev<cr>')
