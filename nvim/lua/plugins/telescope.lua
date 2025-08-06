return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false,
  opts = {
    defaults = {
      layout_strategy = "vertical",
      mappings = {
        n = {
          ["dv"] = "close",
          ["s"] = "move_selection_next",
          ["r"] = "move_selection_previous",
        },
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
    },
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "TelescopeResults",
      command = "setlocal nofoldenable",
    })
  end,
  keys = {
    { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Telescope search files" },
    { "ls", "<cmd>Telescope live_grep<cr>", desc = "Telescope live search" },
    { "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Telescope search buffers" },
  },
}
