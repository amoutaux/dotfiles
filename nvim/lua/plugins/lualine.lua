return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  priority = 1001,
  opts = {
    options = {},
  },
  config = function(_, opts)
    local theme = require("config.theme")
    opts.options.theme = theme.is_dark() and "gruvbox" or "onelight"
    require("lualine").setup(opts)
    vim.opt.showmode = false
  end,
}
