-- 'é' -> 'w'
vim.keymap.set({ "n", "v", "c", "o" }, "é", "w")
vim.keymap.set({ "n", "v", "c", "o" }, "É", "W")
vim.keymap.set("o", "aé", "aw")
vim.keymap.set("o", "aÉ", "aW")
vim.keymap.set("o", "ié", "iw")
vim.keymap.set("o", "iÉ", "iW")
-- 'w' now free for easier window management
vim.keymap.set("", "w", "<C-w>")

-- 'hjkl' -> 'tsrn'
vim.keymap.set("", "t", "h")
vim.keymap.set("", "s", "j")
vim.keymap.set("", "r", "k")
vim.keymap.set("", "n", "l")
vim.keymap.set("", "T", "H")
vim.keymap.set("", "N", "L")

-- 'tsr' -> '<leader>tsr'
vim.keymap.set("", "<leader>t", "t")
vim.keymap.set("", "<leader>s", "s")
vim.keymap.set("", "<leader>r", "r")
vim.keymap.set("", "<leader>R", "R")
-- 'n' -> 'l'
vim.keymap.set("", "l", "n")
vim.keymap.set("", "L", "N")

-- '«»' -> '<>'
vim.keymap.set("", "«", "<")
vim.keymap.set("", "»", ">")

-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.keymap.set("n", "<leader>és", function()
      vim.lsp.buf.workspace_symbol()
    end, { buffer = args.buf })
  end,
})
