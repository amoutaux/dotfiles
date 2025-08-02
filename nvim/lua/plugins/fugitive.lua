return {
  "tpope/vim-fugitive",
  branch = "master",
  lazy = true,
  keys = {
    { "git", "<cmd>Git<cr>" },
    { "S", "<Plug>fugitive:s", mode = { "n", "v" }, ft = { "fugitive", "fugitiveblame" } },
    { "s", "j", mode = { "n", "v" }, ft = { "fugitive", "fugitiveblame" } },
    { "o", "<Plug>fugitive:>", ft = { "fugitive", "fugitiveblame" } },
    { "c", "<Plug>fugitive:<", ft = { "fugitive", "fugitiveblame" } },
    { "<leader>nc", "<Plug>fugitive:)", ft = { "fugitive", "fugitiveblame" } },
    { "<leader>pc", "<Plug>fugitive:(", ft = { "fugitive", "fugitiveblame" } },
    { "<leader>gb", "<cmd>Git blame<cr>" },
    { "<leader>gc", "<cmd>vertical Git commit -v<cr>" },
    { "<leader>gd", "<cmd>Gvdiff!<cr>" },
    { "<leader>dg", "<cmd>diffget<cr>" },
    { "<leader>dp", "<cmd>diffput<cr>" },
  },
}
