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
  end,
  config = function()
    -- Open NERDTree when neovim is called without arguments
    local group = vim.api.nvim_create_augroup("CustomNERDTree", { clear = true })
    vim.api.nvim_create_autocmd("VimEnter", {
      group = group,
      callback = function()
        if vim.fn.argc() == 0 then
          vim.cmd("NERDTreeExplore")
        end
      end,
    })
  end,
  keys = {
    { "<leader>n", "<cmd>NERDTreeFind<cr>" },
  },
}
