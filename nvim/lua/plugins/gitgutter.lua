return {
  "airblade/vim-gitgutter",
  branch = "main",
  lazy = false,
  keys = {
    { "<leader>nc", "<cmd>GitGutterNextHunk<cr>" },
    { "<leader>pc", "<cmd>GitGutterPrevHunk<cr>" },
    { "<leader>do", "<cmd>GitGutterDiffOrig<cr>" },
    { "<leader>sh", "<cmd>GitGutterStageHunk<cr>" },
    { "<leader>uh", "<cmd>GitGutterUndoHunk<cr>" },
  },
}
