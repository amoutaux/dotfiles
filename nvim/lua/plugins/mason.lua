-- Packages are installed in Neovim's data directory by default
return {
  "mason-org/mason.nvim",
  dependencies = { "mason-org/mason-lspconfig.nvim" },
  lazy = false,
  config = function()
    require("mason").setup({})
    -- Automatic install of LSPs
    require("mason-lspconfig").setup({
      automatic_enable = true,
      ensure_installed = {
        "lua_ls",
        "pyright",
      },
    })
  end,
}
