-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Cursor / context
vim.opt.cursorline = true
vim.opt.scrolloff = 8

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Undo
vim.opt.undofile = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Mouse
vim.opt.mouse = "a"

-- Keep the diagnostic / git sign column stable
vim.opt.signcolumn = "yes"

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Modern terminal colors
vim.opt.termguicolors = true

-- Faster UI updates
vim.opt.updatetime = 250
