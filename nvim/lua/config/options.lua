-- Global options
vim.opt.background = 'light'
vim.opt.colorcolumn = '120'
vim.opt.directory=vim.fn.expand('~/.config/nvim/tmp') -- swap files
vim.opt.expandtab = true -- insert spaces instead of tabs
vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.smartcase = true -- search is case-sensitive only if it contains an uppercase letter
vim.opt.splitbelow = true -- open new windows at bottom
vim.opt.textwidth = 80
vim.opt.timeoutlen = 200 -- time spent waiting for second key of a mapping
vim.opt.updatetime = 1000 -- may slow neovim if too low
vim.opt.winborder = 'rounded'

-- Python
vim.g.python3_host_prog = '$VIRTUAL_ENV/bin/python'

-- WARN: clipboard must be set AFTER clipboard providers have been loaded (which
-- may happen after init.lua is run -> use vim.schedule
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- NOTE: for Windows/WSL: install win32yank and make it available in PATH.
