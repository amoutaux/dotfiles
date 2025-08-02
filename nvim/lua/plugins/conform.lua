return {
  "stevearc/conform.nvim",
  lazy = false,
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format()
      end,
      mode = "n",
    },
  },
  -- This will provide type hinting with LuaLS
  ---@module 'conform'
  ---@type conform.setupOpts
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
    },

    -- Set default options
    default_format_opts = {
      lsp_format = "never",
    },

    -- Auto format on save
    format_on_save = {},

    -- Customize formatters
    formatters = {
      stylua = {
        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      },
      shfmt = {
        prepend_args = { "-i", "2" },
      },
    },
  },
  config = function(_, opts)
    local conform = require("conform")
    conform.setup(opts)

    local mygroup = vim.api.nvim_create_augroup("MyCustomConform", { clear = true })
    vim.api.nvim_create_autocmd("BufReadPost", {
      group = mygroup,
      callback = function(args)
        local expected_formatters = opts.formatters_by_ft[vim.bo.filetype]
        for _, ef in pairs(expected_formatters) do
          local f = conform.get_formatter_info(ef, args.buf)
          if f.available == false then
            vim.notify(f.name .. " is not available", vim.log.levels.WARN)
          end
        end
      end,
    })
  end,
}
