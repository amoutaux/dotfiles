return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  priority = 1001,
  opts = {
    options = {
      --theme = "ayu_light",
      theme = "onelight",
    },
  },
  config = function(_, opts)
    require("lualine").setup(opts)
    vim.opt.showmode = false
  end,
}
