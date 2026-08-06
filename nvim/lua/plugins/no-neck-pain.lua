return {
  "shortcuts/no-neck-pain.nvim",
  lazy = false,
  keys = {
    { "<leader>np", "<cmd>NoNeckPain<cr>" },
  },
  opts = {
    autocmds = {
      enableOnVimEnter = "safe", -- fixes `nvim -d` opening 3-way diff view
    },
    disableOnLastBuffer = false,
    mappings = {
      enabled = true,
    },
    width = 120,
  },
  config = function(_, opts)
    local nnp = require("no-neck-pain")
    nnp.setup(opts)

    local repeatable = require("helpers.repeatable_keymap")
    repeatable.keymap_set_repeatable("n", "<leader>np+", function()
      local current_width = vim.api.nvim_win_get_width(0)
      nnp.resize(current_width + 5)
    end)
    repeatable.keymap_set_repeatable("n", "<leader>np-", function()
      local current_width = vim.api.nvim_win_get_width(0)
      nnp.resize(current_width - 5)
    end)

  end,
}
