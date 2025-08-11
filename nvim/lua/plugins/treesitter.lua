return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    auto_install = true,
    ensure_installed = { "c", "javascript", "lua", "python", "vimdoc" },
    -- Wouldn't be added to runtime path if not explicitly specified ¯\_(ツ)_/¯
    install_dir = vim.fn.stdpath("data") .. "/site",
  },
}
