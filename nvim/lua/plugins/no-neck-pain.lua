return {
  "shortcuts/no-neck-pain.nvim",
  lazy = false,
  opts = {
    autocmds = {
      enableOnVimEnter = true
    }
  },
  keys = {
    { "<leader>mi", "<cmd>NoNeckPain<cr>"},
  },
}
