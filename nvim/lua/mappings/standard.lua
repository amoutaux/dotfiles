vim.keymap.set({ "i", "n", "v", "x", "c" }, "dv", "<Esc>")
vim.keymap.set("", "<leader>h", "<cmd>noh<cr>") -- No Highlight
vim.keymap.set("n", "<leader>d", "<C-]>") -- Go to def
vim.keymap.set("n", "<C-n>", "<C-w>w") -- Window management
vim.keymap.set("n", "gpf", "<cmd>e#<cr>") -- Go previous file
vim.keymap.set("n", "//", "/\\<\\><Left><Left>") -- Search with boundaries

-- Some layouts print curly quotes instead of plain ones
vim.keymap.set({ "i", "n", "v", "x", "c", "o" }, "’", "'", { remap = true })

-- Vertical help
vim.keymap.set("c", "help", "vertical bo help")

-- Better Up/Down
vim.keymap.set({ "n" }, "<C-u>", "10kzz")
vim.keymap.set({ "n" }, "<C-d>", "10jzz")

-- Quickfix list
vim.keymap.set("", "<leader>cn", "<cmd>cnext<cr>")
vim.keymap.set("", "<leader>cp", "<cmd>cprev<cr>")

-- Netrw
-- Rq: Lexplore is the only command that closes netrw if it's already opened
-- Rq: %:p:h opens netrw in the current file directory (not the working directory)
vim.keymap.set("n", "<leader>N", "<cmd>Lexplore %p:h<cr>", { silent = true })
vim.keymap.set("n", "<leader>NQ", "<cmd>Lexplore<cr>")
