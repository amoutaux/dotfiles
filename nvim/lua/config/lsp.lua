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
    -- vim.keymap.set("n", "<leader>f", function()
      -- vim.lsp.buf.format()
    -- end, { buffer = args.buf })
  end,
})

-- LSPs
vim.lsp.config("*", {
  root_markers = { ".git" }, -- base directory for lsp workspace
})

-- Deactivate diagnostics from LSP for chef files (cookstyle preferred)
local mygroup = vim.api.nvim_create_augroup("MyCustomLSP", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = mygroup,
  callback = function(args)
    if vim.bo[args.buf].filetype == "chef" then
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      --https://github.com/neovim/neovim/issues/20745
      client.handlers["textDocument/publishDiagnostics"] = function(...)
          local result = select(2, ...)
          result.diagnostics = {}
      end
    end
  end
})
-- Mason takes care of enabling installed LSPs
-- vim.lsp.enable({ ... })
