return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
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
    require('telescope').setup(opts)
    local builtin = require('telescope.builtin')
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "TelescopeResults",
      command = "setlocal nofoldenable",
    })

    -- vim.keymap.set("n", "<leader>sw", builtin.find_files)
    vim.keymap.set("n", "<leader>sb", builtin.buffers)
    vim.keymap.set("n", "<leader>sc", function ()
      builtin.git_commits({sorting_strategy = "ascending"})
    end)
    vim.keymap.set("n", "<leader>sd", builtin.lsp_definitions)
    vim.keymap.set("n", "<leader>sf", builtin.find_files)
    vim.keymap.set("n", "<leader>sr", builtin.lsp_references)
    vim.keymap.set("n", "<leader>ss", builtin.lsp_document_symbols)
    vim.keymap.set("n", "<leader>sS", builtin.lsp_dynamic_workspace_symbols)
    vim.keymap.set("n", "<leader>sw", builtin.live_grep)
    vim.keymap.set("n", "<leader>sé", builtin.live_grep)
  end,
}
