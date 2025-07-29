return {
    "preservim/nerdtree", branch = "master",
    init = function()
        vim.g.NERDTreeMapChdir = 'H'
        vim.g.NERDTreeMapChdir = 'hd'
        vim.g.NERDTreeMapCWD = 'HD'
        vim.g.NERDTreeMapOpenInTab = 'j'
        vim.g.NERDTreeMapJumpLastChild = 'J'
        vim.g.NERDTreeMapOpenVSplit = 'k'
        vim.g.NERDTreeMapRefresh = 'l'
        vim.g.NERDTreeMapRefreshRoot = 'L'
    end,
    keys = {
        {"<leader>n", "<cmd>NERDTreeFind<cr>"},
    },
}

