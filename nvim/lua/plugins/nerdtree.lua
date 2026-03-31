return {
  "preservim/nerdtree",
  lazy = false, -- needed to open folders directly with NERDTree
  init = function()
    vim.g.NERDTreeMapChdir = "H"
    vim.g.NERDTreeMapChdir = "hd"
    vim.g.NERDTreeMapCWD = "HD"
    vim.g.NERDTreeMapOpenInTab = "j"
    vim.g.NERDTreeMapJumpLastChild = "J"
    vim.g.NERDTreeMapOpenVSplit = "k"
    vim.g.NERDTreeMapRefresh = "l"
    vim.g.NERDTreeMapRefreshRoot = "L"
    vim.g.NERDTreeMinimalUI = 1
    vim.g.NERDTreeQuitOnOpen = 1
    vim.g.NERDTreeWinSize = 50
    vim.g.NERDTreeShowLineNumbers = true
  end,
  keys = {
    { "<leader>n", "<cmd>NERDTreeFind<cr>" },
  },
}
