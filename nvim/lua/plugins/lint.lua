return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  lazy = false,
  config = function()
    local mygroup = vim.api.nvim_create_augroup("MyCustomLint", { clear = true })
    local lint = require("lint")
    local parser = require("lint.parser")

    -- Linters by filetype
    lint.linters_by_ft = {
      chef = { "cookstyle", "rubocop" },
      groovy = { "npm-groovy-lint" },
      markdown = { "markdownlint" },
      python = { "mypy", "pylint" },
      ruby = { "rubocop" },
      yaml = { "yamllint" },
    }

    -- Configuration
    lint.linters.cookstyle = {
      -- Cookstyle is not built-in so we have to tell nvim-lint how to use it
      cmd = "cookstyle",
      args = { "--format", "json" },
      parser = parser.for_sarif(),
    }

    -- Automatic linting
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = mygroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
