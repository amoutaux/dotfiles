return {
  "sindrets/diffview.nvim",
  config = function(_, opts)
    require("diffview").setup(opts)
    local actions = require("diffview.actions")

    -- Cleanup mappings conflicting with bepo within ft = DiffviewFiles
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "DiffviewFiles",
      callback = function(args)
        vim.schedule(function() -- execute after diffview to ensure overwrite
          vim.keymap.del("n", "s", { buffer = args.buf })
          vim.keymap.del("n", "S", { buffer = args.buf })
          vim.keymap.set("n", "S", actions.toggle_stage_entry, { buffer = args.buf })
        end)
      end,
    })
  end,
}
