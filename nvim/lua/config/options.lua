-- Global options
vim.opt.autoread = true -- reload file if it has been changed outside of nvim
vim.opt.clipboard = "unnamedplus" -- cut/copy/paste shared between vim instances and computer
vim.opt.directory = vim.fn.expand("~/.config/nvim/tmp") -- swap files
vim.opt.expandtab = true -- insert spaces instead of tabs
vim.opt.foldmethod = "indent"
vim.opt.ignorecase = true
vim.opt.list = true
vim.opt.listchars = "trail:~,tab:..,nbsp:&," --select specific whitespaces
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smartcase = true -- search is case-sensitive only if it contains an uppercase letter
vim.opt.splitbelow = true -- open new windows at bottom
vim.opt.textwidth = 80
vim.opt.timeoutlen = 200 -- time spent waiting for second key of a mapping
vim.opt.undolevels = 1000 -- set number of changes that are stored so they can be undone
vim.opt.updatetime = 1000 -- may slow neovim if too low
vim.opt.winborder = "rounded"

-- Netrw
vim.g.netrw_preview = 1 -- preview window shown in a vertical split"
vim.g.netrw_banner = 0 -- hide netrw comment banner"
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25

-- Python
vim.g.python3_host_prog = "$VIRTUAL_ENV/bin/python3"

-- WARN: clipboard must be set AFTER clipboard providers have been loaded (which
-- may happen after init.lua is run -> use vim.schedule
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- NOTE: for Windows/WSL: install win32yank and make it available in PATH.
