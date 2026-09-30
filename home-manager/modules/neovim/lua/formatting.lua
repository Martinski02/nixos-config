local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    nix = { "nixfmt" },
    lua = { "stylua" },
    python = { "black" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    sh = { "shfmt" },
  },
})

vim.keymap.set({ "n", "v" }, "<leader>lf", function()
  conform.format({
    async = false,
    lsp_format = "fallback",
  })
end, {
  desc = "Format buffer / selection",
})
