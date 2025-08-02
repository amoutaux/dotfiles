return {
    'ellisonleao/gruvbox.nvim',
    branch = 'main',
    lazy = false,
    priority = 1000,
    opts = {
        contrast = 'dark',
        palette_overrides = {
            light0_hard = '#fcfcfc', -- Closer to white, very subtle off-white
            light0 = '#ffffff',      -- Pure white, often used for main background
            light0_soft = '#f8f8f8', -- Slightly off-white, brighter than original
            light1 = '#f0f0f0',      -- Light grey, brighter than original
            light2 = '#e8e8e8',      -- Medium light grey, brighter than original
            light3 = '#d0d0d0',      -- Darker light grey, brighter than original
            light4 = '#c0c0c0',      -- Even darker light grey, brighter than original        },
        },
    },
    config = function(_, opts)
        require('gruvbox').setup(opts)
        vim.cmd([[colorscheme gruvbox]])
        vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'white' })
    end,
}
