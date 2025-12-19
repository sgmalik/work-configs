vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.opt.number          = true       -- show absolute line numbers
vim.opt.relativenumber  = true       -- show relative line numbers
vim.opt.cursorline      = true       -- highlight the current line
vim.opt.signcolumn      = "yes"      -- always show the sign column (e.g. for diagnostics)
vim.opt.termguicolors   = true       -- enable 24‑bit RGB colors
-- Use the system clipboard for all yank, delete and paste operations
vim.opt.clipboard = "unnamedplus"

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>l", ":Lazy <CR>", {})
