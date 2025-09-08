return {
  "tpope/vim-fugitive",
  branch = "master",
  lazy = false,
  keys = {
    { "git", "<cmd>Gtabedit :<cr>" }, -- https://github.com/tpope/vim-fugitive/issues/727
    { "log", "<cmd>Git log --oneline --all --graph --decorate<cr>" },
    { "S", "<Plug>fugitive:s", mode = { "n", "v" }, ft = { "fugitive", "fugitiveblame" } },
    { "s", "j", mode = { "n", "v" }, ft = { "fugitive", "fugitiveblame" } },
    { "o", "<Plug>fugitive:>", ft = { "fugitive", "fugitiveblame" } },
    { "c", "<Plug>fugitive:<", ft = { "fugitive", "fugitiveblame" } },
    { "nc", "<Plug>fugitive:)", ft = { "fugitive", "fugitiveblame" } },
    { "pc", "<Plug>fugitive:(", ft = { "fugitive", "fugitiveblame" } },
    { "bl", "<cmd>Git blame<cr>" },
    { "co", "<cmd>vertical Git commit -v<cr>" },
    { "di", "<cmd>Gvdiff!<cr>", mode = { "n", "v" } },
    { "ge", "<cmd>diffget<cr>", mode = { "n", "v" } },
    { "pu", "<cmd>diffput<cr>", mode = { "n", "v" } },
  },
}
