vim.keymap.set('', 'é', 'w')
vim.keymap.set('c', 'é', 'w')
vim.keymap.set('', '<C-é>', '<C-w>')
vim.keymap.set('', 'É', 'W')

-- ’hjkl’ -> ’tsrn’
vim.keymap.set('', 't', 'h', { noremap = true })
vim.keymap.set('', 's', 'j', { noremap = true })
vim.keymap.set('', 'r', 'k', { noremap = true })
vim.keymap.set('', 'n', 'l', { noremap = true })
vim.keymap.set('', 'T', 'H', { noremap = true })
vim.keymap.set('', 'N', 'L', { noremap = true })

-- ’tsr’ -> ’<leader>tsr’
vim.keymap.set('', '<leader>t', 't', { noremap = true })
vim.keymap.set('', '<leader>s', 's', { noremap = true })
vim.keymap.set('', '<leader>r', 'r', { noremap = true })
vim.keymap.set('', '<leader>R', 'R', { noremap = true })
-- ’n’ -> ’l’
vim.keymap.set('', 'l', 'n', { noremap = true })
vim.keymap.set('', 'L', 'N', { noremap = true })

-- ’«»’ -> ’<>’
vim.keymap.set('', '«', '<', { noremap = true })
vim.keymap.set('', '»', '>', { noremap = true })

-- LSP
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        vim.keymap.set('n', '<leader>és', function() vim.lsp.buf.workspace_symbol() end, { buffer = args.buf })
    end
})
