-- Packages are installed in Neovim's data directory by default
return {
    'mason-org/mason.nvim',
    lazy = false,
    config = function()
        require('mason').setup({})
        local registry = require('mason-registry')
        local package_list = {
            --WARN: do not install linters/fixers meant to live in a virtual environment
            --LSP
            'pyright',
            'lua-language-server',
            'hoho',
            --Formatters
            'stylua',
        }
        for _, package in ipairs(package_list) do
            if registry.is_installed(package) == false then
                vim.notify('⚠️ ' .. package .. ' is NOT installed!')
            end
        end
    end,
}
