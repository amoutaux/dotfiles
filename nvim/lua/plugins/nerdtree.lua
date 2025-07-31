return {
    'preservim/nerdtree', branch = 'master',
    lazy = false, -- needed to open folders directly with NERDTree
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
    config = function()
        -- Open Folders with NERDTree (instead of netrw)
        vim.api.nvim_create_autocmd("VimEnter", {
          callback = function()
            if vim.fn.argc() == 0 or (vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0))) then
              -- Check if NERDTree is loaded and not already active in the current window
              -- This check prevents opening NERDTree if you're already in a NERDTree buffer or if it's not installed.
              if vim.fn.exists(":NERDTreeToggle") == 2 and vim.fn.bufname('%'):match('NERD_tree') == nil then
                vim.cmd("NERDTree")
              end
            end
          end,
        })
    end,
    keys = {
        {'<leader>n', '<cmd>NERDTreeFind<cr>'},
    },
}

