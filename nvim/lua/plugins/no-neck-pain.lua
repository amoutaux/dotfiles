return {
  "shortcuts/no-neck-pain.nvim",
  lazy = false,
  opts = {
    autocmds = {
      enableOnVimEnter = "safe" -- fixes `nvim -d` opening 3-way diff view
    }
  },
  keys = {
    { "<leader>mi", "<cmd>NoNeckPain<cr>"},
  },
}
