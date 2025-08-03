local function is_in(tab, val)
  for _, v in pairs(tab) do
    if v == val then
      return true
    end
  end
  return false
end

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  lazy = false,
  config = function(_, opts)
    local mygroup = vim.api.nvim_create_augroup("MyCustomLint", { clear = true })
    local lint = require("lint")
    lint.linters_by_ft = {
      chef = { "cookstyle", "rubocop" },
      groovy = { "npm-groovy-lint" },
      markdown = { "markdownlint" },
      python = { "mypy", "pylint" },
      ruby = { "rubocop" },
      yaml = { "yamllint" },
    }
    -- Lint upon
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = mygroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
