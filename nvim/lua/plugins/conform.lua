local indents_by_ft = {
  c = {
    indent = 2,
    textwidth = 80,
    pattern = { "*.c", "*.cpp" },
  },
  git = {
    indent = 2,
    textwidth = 72,
    pattern = "COMMIT_EDITMSG",
  },
  groovy = {
    indent = 4,
    textwidth = 120,
    pattern = "*.groovy",
  },
  lua = {
    indent = 2,
    textwidth = 100,
    pattern = "*.lua",
  },
  markdown = {
    indent = 4,
    textwidth = 120,
    pattern = "*.md",
  },
  python = {
    indent = 4,
    textwidth = 88,
    pattern = "*.py",
  },
  ruby = {
    indent = 2,
    textwidth = 100,
    pattern = "*.rb",
  },
  sh = {
    indent = 4,
    textwidth = 80,
    pattern = { "*.bash", "*.sh" },
  },
}

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
      c = { "clang-format" },
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

    formatters = {
      stylua = {
        prepend_args = {
          "--indent-type",
          "Spaces",
          "--indent-width",
          indents_by_ft.lua.indent,
          "--column-width",
          indents_by_ft.lua.textwidth,
        },
      },
      shfmt = { prepend_args = { "--indent", indents_by_ft.sh.indent } },
    },
  },
  config = function(_, opts)
    local conform = require("conform")
    local mygroup = vim.api.nvim_create_augroup("MyCustomConform", { clear = true })

    -- Indentation management
    for _, options in pairs(indents_by_ft) do
      vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        group = mygroup,
        pattern = options.pattern,
        callback = function()
          vim.opt.shiftwidth = options.indent
          vim.opt.textwidth = options.textwidth
          vim.opt.colorcolumn = tostring(options.textwidth)
        end,
      })
    end

    conform.setup(opts)

    -- Notify if a configured formatter is not available
    vim.api.nvim_create_autocmd("BufRead", {
      group = mygroup,
      callback = function(args)
        local expected_formatters = opts.formatters_by_ft[vim.bo.filetype]
        for _, ef in pairs(expected_formatters or {}) do
          local f = conform.get_formatter_info(ef, args.buf)
          if f.available == false then
            vim.notify("⚠️ " .. f.name .. " is not available", vim.log.levels.WARN)
          end
        end
      end,
    })

    -- Recognize Jenkinsfiles as groovy + custom shiftwidth
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
