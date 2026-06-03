return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  lazy = false,
  keys = {
    {
      "<leader>l",
      function()
        require("lint").try_lint()
      end,
      mode = "n",
    },
  },
  config = function()
    local mygroup = vim.api.nvim_create_augroup("MyCustomLint", { clear = true })
    local lint = require("lint")
    local parser = require("lint.parser")

    -- Linters by filetype
    lint.linters_by_ft = {
      chef = { "cookstyle" },
      dockerfile = { "hadolint" },
      groovy = { "npm-groovy-lint" },
      json = { "jsonlint" },
      markdown = { "markdownlint" },
      python = { "mypy", "pylint" },
      ruby = { "rubocop" },
      yaml = { "yamllint" },
      sh = { "shellcheck" },
      terraform = { "terraform_validate" },
      tf = { "terraform_validate" },
    }

    -- Configuration
    lint.linters.cookstyle = {
      -- Cookstyle is not built-in so we have to tell nvim-lint how to use it
      cmd = "cookstyle",
      parser = parser.from_errorformat(),
    }

    table.insert(lint.linters.markdownlint.args, 1, "--config")
    table.insert(lint.linters.markdownlint.args, 2, vim.fn.expand("~/.markdownlint.yaml"))

    table.insert(lint.linters.pylint.args, 1, "-j")
    table.insert(lint.linters.pylint.args, 2, "4")

    table.insert(lint.linters.shellcheck.args, 1, "-x")

    -- https://deepwiki.com/mfussenegger/nvim-lint/7-configuration-guide#performance-optimization
    local lint_timer = nil
    local function debounced_lint()
      if lint_timer then
        lint_timer:stop()
      end
      lint_timer = vim.defer_fn(function()
        require("lint").try_lint()
      end, 500) -- 500ms delay
    end

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWrite", "TextChanged" }, {
      group = mygroup,
      callback = debounced_lint,
    })

    -- Ensure all configured linters are available
    local check_current_linters = function()
      local ft = vim.bo.filetype
      local configured = lint.linters_by_ft[ft] or {}

      if vim.tbl_isempty(configured) then
        print("No linters configured for " .. ft)
        return
      end

      local available = {}
      for _, linter_name in ipairs(configured) do
        local linter = lint.linters[linter_name]
        -- check linter exists and vim can find executable
        if linter then
          if type(linter) == "function" then
            linter = linter()
          end
          if vim.fn.executable(linter.cmd) == 1 then
            table.insert(available, linter_name)
          end
        end
      end

      if #available ~= #configured then
        -- Construct and print missing table
        local missing = {}
        local available_set = {}
        for _, name in ipairs(available) do
          available_set[name] = true
        end
        for _, name in ipairs(configured) do
          if not available_set[name] then
            table.insert(missing, name)
          end
        end

        print("⚠️ Some configured linters are not available..")
        print("Configured: " .. table.concat(configured, ", "))
        print("Available: " .. table.concat(available, ", "))
        print("Missing: " .. table.concat(missing, ", "))
        return
      else
        print("✅ All configured linters are available")
        print("Configured: " .. table.concat(configured, ", "))
        return
      end
    end

    vim.api.nvim_create_user_command("LintersInfo", check_current_linters, {})
  end,
}
