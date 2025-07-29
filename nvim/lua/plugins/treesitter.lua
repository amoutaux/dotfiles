return {
    "nvim-treesitter/nvim-treesitter", branch = 'main',
    lazy = false,
    build = ":TSUpdate",
    opts = {
        auto_install = true,
        ensure_installed = { "c", "javascript", "lua", "python", "vimdoc"}
    }
}
