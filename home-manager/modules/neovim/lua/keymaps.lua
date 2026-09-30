local map = vim.keymap.set

-- File explorer
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", {
  desc = "Toggle file explorer",
})

-- Search
local telescope = require("telescope.builtin")

map("n", "<leader>ff", telescope.find_files, {
  desc = "Find files",
})

map("n", "<leader>fg", telescope.live_grep, {
  desc = "Find text",
})

map("n", "<leader>fb", telescope.buffers, {
  desc = "Find open buffers",
})

map("n", "<leader>fh", telescope.help_tags, {
  desc = "Find help",
})

-- Git
map("n", "<leader>gp", function()
  require("gitsigns").preview_hunk()
end, {
  desc = "Preview hunk",
})

map("n", "<leader>gb", function()
  require("gitsigns").blame_line({
    full = true,
  })
end, {
  desc = "Blame line",
})

map("n", "<leader>gd", function()
  require("gitsigns").diffthis()
end, {
  desc = "Diff file",
})

-- LSP mappings only exist where an LSP is actually attached.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = {
      buffer = event.buf,
    }

    map("n", "<leader>ld", vim.lsp.buf.definition, vim.tbl_extend("force", opts, {
      desc = "Go to definition",
    }))

    map("n", "<leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, {
      desc = "Rename symbol",
    }))

    map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, {
      desc = "Code action",
    }))

    map("n", "<leader>lh", vim.lsp.buf.hover, vim.tbl_extend("force", opts, {
      desc = "Hover documentation",
    }))

    map("n", "<leader>le", vim.diagnostic.open_float, vim.tbl_extend("force", opts, {
      desc = "Show diagnostic",
    }))
  end,
})
