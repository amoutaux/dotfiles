return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    opts = {
        auto_install = true,
        ensure_installed = { 'c', 'javascript', 'lua', 'python', 'vimdoc' }
    }
}
