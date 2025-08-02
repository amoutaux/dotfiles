-- Mappings
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        --- CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|
        vim.keymap.set('n', '<leader>d', function() vim.lsp.buf.definition() end, { buffer = args.buf })
        vim.keymap.set('n', '<leader>i', function() vim.lsp.buf.implementation() end, { buffer = args.buf })
        vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format() end, { buffer = args.buf })
        vim.keymap.set('n', '<leader>re', function() vim.lsp.buf.references() end, { buffer = args.buf })
        vim.keymap.set('n', '<leader>rn', function() vim.lsp.buf.rename() end, { buffer = args.buf })
        vim.keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, { buffer = args.buf })
        vim.keymap.set('n', 'H', function() vim.lsp.buf.hover() end, { buffer = args.buf })
        vim.keymap.set('n', '<leader>ws', function() vim.lsp.buf.workspace_symbol() end, { buffer = args.buf })
        vim.keymap.set('n', '<leader>ne', function() vim.diagnostic.jump({ count = 1, float = true }) end,
            { buffer = args.buf })
        vim.keymap.set('n', '<leader>pe', function() vim.diagnostic.jump({ count = -1, float = true }) end,
            { buffer = args.buf })
    end,
})

-- LSPs
vim.lsp.config('*', {
    root_markers = { '.git' }, -- base directory for lsp workspace
})

vim.lsp.enable({
    'lua_ls',
    'pyright'
})

-- define the diagnostic signs.
local diagnostic_icons = require('icons').diagnostics

for severity, icon in pairs(diagnostic_icons) do
    local hl = 'diagnosticsign' .. severity:sub(1, 1) .. severity:sub(2):lower()
    vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

-- diagnostic configuration.
vim.diagnostic.config {
    virtual_text = {
        -- show severity icons as prefixes.
        prefix = function(diagnostic)
            return diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]] .. ' '
        end,
        -- show only the first line of each diagnostic.
        format = function(diagnostic)
            return vim.split(diagnostic.message, '\n')[1]
        end,
    },
    float = {
        border = 'rounded',
        source = 'if_many',
        -- show severity icons as prefixes.
        prefix = function(diag)
            local level = vim.diagnostic.severity[diag.severity]
            local prefix = string.format(' %s ', diagnostic_icons[level])
            return prefix, 'diagnostic' .. level:gsub('^%l', string.upper)
        end,
    },
    -- enable signs in the gutter.
    signs = true,
}
