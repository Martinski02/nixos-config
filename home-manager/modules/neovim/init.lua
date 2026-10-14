-- 42 identity
vim.g.user42 = "mabarbie"
vim.g.mail42 = "mabarbie@learner.42.tech"

-- nvim-tree replaces netrw as the file explorer.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("options")
require("theme")
require("plugins")
require("lsp")
require("formatting")
require("norminette")
require("keymaps")
