local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    nix = { "nixfmt" },
    lua = { "stylua" },
    python = { "black" },
    c = { "c_formatter_42" },
    cpp = { "clang_format" },
    sh = { "shfmt" },
  },

  formatters = {
    c_formatter_42 = {
      command = "c_formatter_42",
      stdin = true,
    },
  },
})

vim.keymap.set({ "n", "v" }, "<leader>lf", function()
  conform.format({
    async = false,
    lsp_format = "never",
  })
end, {
  desc = "Format buffer / selection",
})
