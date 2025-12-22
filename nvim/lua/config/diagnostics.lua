-- Diagnostics

-- Generic Diagnostics mappings
vim.keymap.set("n", "D", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end)
vim.keymap.set("n", "ce", function() -- open current error in float window
  vim.diagnostic.open_float()
end)
vim.keymap.set("n", "ne", function()
  vim.diagnostic.jump({ count = 1, float = true })
end)
vim.keymap.set("n", "pe", function()
  vim.diagnostic.jump({ count = -1, float = true })
end)

-- Icons
local diagnostic_icons = require("icons").diagnostics
for severity, icon in pairs(diagnostic_icons) do
  local hl = "diagnosticsign" .. severity:sub(1, 1) .. severity:sub(2):lower()
  vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

-- Custom handler to help troubleshooting
vim.diagnostic.handlers["my/debug_diagnostics"] = {
  show = function(namespace, bufnr, diagnostics, opts)
    local source_name = vim.diagnostic.get_namespace(namespace).name
    local msg = string.format(
      "%d diagnostics in buffer %d from %s",
      #diagnostics,
      bufnr,
      source_name
    )
    local level = vim.log.levels.DEBUG
    vim.notify(msg, level)
  end,
}

vim.diagnostic.config({
  ["my/debug_diagnostics"] = true,
  underline = true,
  virtual_text = {
    -- show severity icons as prefixes.
    prefix = function(diagnostic)
      return diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]] .. " "
    end,
    -- show only the first line of each diagnostic.
    format = function(diagnostic)
      return vim.split(diagnostic.message, "\n")[1]
    end,
  },
  float = {
    header = "",
    border = "rounded",
    source = true,
    -- show severity icons as prefixes.
    prefix = function(diag)
      local level = vim.diagnostic.severity[diag.severity]
      local prefix = string.format(" %s ", diagnostic_icons[level])
      return prefix, "diagnostic" .. level:gsub("^%l", string.upper)
    end,
  },
  -- enable signs in the gutter.
  signs = true,
})
