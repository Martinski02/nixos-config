vim.o.background = "dark"

require("kanagawa").setup({
  theme = "wave",
  transparent = true,

  background = {
    dark = "wave",
    light = "lotus",
  },
})

vim.cmd.colorscheme("kanagawa-wave")
