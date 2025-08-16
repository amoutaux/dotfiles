return {
  "ellisonleao/gruvbox.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    palette_overrides = {
      light0_hard = "#fcfcfc", -- Closer to white, very subtle off-white
      light0 = "#ffffff", -- Pure white, often used for main background
      light0_soft = "#f8f8f8", -- Slightly off-white, brighter than original
      light1 = "#d0d0d0",
      light2 = "#a8a8a8",
      light3 = "#888888",
      light4 = "#606060",
    },
  },
  config = function(_, opts)
    require("gruvbox").setup(opts)
    vim.cmd([[colorscheme gruvbox]])
    -- Darker whitespaces
    vim.api.nvim_set_hl(0, "hitespace", { fg = opts.palette_overrides.light4 })
    -- Make floating windows background
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = opts.palette_overrides.light0_soft })
    -- Overwrite default diff colors
    vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#d5f5dc" })
    vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#ffe4e1" })
    vim.api.nvim_set_hl(0, "DiffChange", { bg = "#ffefd5" })
  end,
}
