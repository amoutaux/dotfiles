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
      chef = { "rubocop" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      json = { "fixjson" },
      lua = { "stylua" },
      markdown = { "mdformat" },
      python = { "black", "isort", "autopep8" },
      ruby = { "rubocop" },
      sh = { "shfmt" },
      swift = { "swiftformat" },
      terraform = { "terraform_fmt" },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      yaml = { "yamlfmt" },
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
        prepend_args = {
          "--indent-type",
          "Spaces",
          "--indent-width",
          "2",
          "--column-width",
          "120",
        },
      },
      shfmt = {
        prepend_args = { "-i", "2" },
      },
    },
  },
  config = function(_, opts)
    local conform = require("conform")
    conform.setup(opts)

    -- Notify if a configured formatter is not available
    local mygroup =
      vim.api.nvim_create_augroup("MyCustomConform", { clear = true })
    vim.api.nvim_create_autocmd("BufRead", {
      group = mygroup,
      callback = function(args)
        local expected_formatters = opts.formatters_by_ft[vim.bo.filetype]
        for _, ef in pairs(expected_formatters or {}) do
          local f = conform.get_formatter_info(ef, args.buf)
          if f.available == false then
            vim.notify(
              "⚠️ " .. f.name .. " is not available",
              vim.log.levels.WARN
            )
          end
        end
      end,
    })

    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
      group = mygroup,
      pattern = "COMMIT_EDITMSG",
      callback = function()
        vim.opt.shiftwidth = 2
        vim.opt.textwidth = 80
        vim.opt.colorcolumn = "80"
      end,
    })

    -- Set shiftwidth and colorcolumn per filetype
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
      group = mygroup,
      pattern = "*.lua",
      callback = function()
        vim.opt.shiftwidth = 2
        vim.opt.textwidth = 120
        vim.opt.colorcolumn = "120"
      end,
    })

    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
      group = mygroup,
      pattern = "*.groovy",
      callback = function()
        vim.opt.shiftwidth = 4
        vim.opt.textwidth = 120
        vim.opt.colorcolumn = "120"
      end,
    })

    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
      group = mygroup,
      pattern = "*.md",
      callback = function()
        vim.opt.shiftwidth = 4
        vim.opt.textwidth = 120
        vim.opt.colorcolumn = "120"
      end,
    })

    -- Recognize Jenkinsfiles as groovy
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
      group = mygroup,
      pattern = {
        "*.jenkinsfile",
        "*.Jenkinsfile",
        "Jenkinsfile",
        "jenkinsfile",
      },
      callback = function()
        vim.bo.filetype = "groovy"
        vim.opt.shiftwidth = 2
        vim.colorcolumn = 120
      end,
    })

    --Recognize ruby files in a 'chef folder' as chef files
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
      group = mygroup,
      pattern = {
        "*/recipes/*.rb",
        "*/providers/*.rb",
        "*/resources/*.rb",
        "*/attributes/*.rb",
      },
      callback = function()
        vim.cmd("set ft=chef syntax=ruby")
      end,
    })
  end,
}
