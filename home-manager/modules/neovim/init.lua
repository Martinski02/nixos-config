-- nvim-tree replaces netrw as the file explorer.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("options")
require("theme")
require("plugins")
require("lsp")
require("formatting")
require("keymaps")
