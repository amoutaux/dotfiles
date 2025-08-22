-- Generic Diagnostics mappings
vim.keymap.set("n", "D", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end)
vim.keymap.set("n", "ne", function()
  vim.diagnostic.jump({ count = 1, float = true })
end)
vim.keymap.set("n", "pe", function()
  vim.diagnostic.jump({ count = -1, float = true })
end)

-- LSP Mappings
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    --- CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|
    vim.keymap.set("n", "<leader>d", function()
      vim.lsp.buf.definition()
    end, { buffer = args.buf })
    vim.keymap.set("n", "<leader>i", function()
      vim.lsp.buf.implementation()
    end, { buffer = args.buf })
    vim.keymap.set("n", "<leader>re", function()
      vim.lsp.buf.references()
    end, { buffer = args.buf })
    vim.keymap.set("n", "<leader>rn", function()
      vim.lsp.buf.rename()
    end, { buffer = args.buf })
    vim.keymap.set("n", "ca", function()
      vim.lsp.buf.code_action()
    end, { buffer = args.buf })
    vim.keymap.set("n", "H", function()
      vim.lsp.buf.hover()
    end, { buffer = args.buf })
    vim.keymap.set("n", "<leader>ws", function()
      vim.lsp.guf.workspace_symbol()
    end, { buffer = args.buf })
    vim.keymap.set("n", "ne", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, { buffer = args.buf })
    vim.keymap.set("n", "pe", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, { buffer = args.buf })
    --Use conform and dedicated formatters, never rely on LSP.
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format()
    end, { buffer = args.buf })
  end,
})

-- LSPs
vim.lsp.config("*", {
  root_markers = { ".git" }, -- base directory for lsp workspace
})

-- Mason takes care of enabling installed LSPs
-- vim.lsp.enable({ ... })

-- Diagnostics
--
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
  underline = false,
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
