-- File explorer
require("nvim-tree").setup({
  view = {
    width = 32,
  },

  renderer = {
    group_empty = true,
  },

  update_focused_file = {
    enable = true,
    update_root = false,
  },
})

-- Search / fuzzy finder
require("telescope").setup({
  defaults = {
    path_display = { "smart" },
  },
})

-- Keybinding helper
local wk = require("which-key")

wk.setup({})

wk.add({
  { "<leader>f", group = "Find" },
  { "<leader>g", group = "Git" },
  { "<leader>l", group = "LSP / Code" },
})

-- Statusline
require("lualine").setup({
  options = {
    theme = "auto",
    globalstatus = true,
  },

  sections = {
    lualine_a = {
      "mode",
    },

    lualine_b = {
      "branch",
      "diagnostics",
    },

    lualine_c = {
      {
        "filename",
        path = 1,
      },
    },

    lualine_x = {
      "filetype",
    },

    lualine_y = {
      "progress",
    },

    lualine_z = {
      "location",
    },
  },
})

-- Automatic bracket / quote pairs
require("nvim-autopairs").setup({})

-- Git indicators
require("gitsigns").setup({})

local function hide_completion_after_move(cmp)
  cmp.hide()

  vim.schedule(function()
    require("blink.cmp").hide()
  end)

  return false
end

-- Completion
require("blink.cmp").setup({
  keymap = {
    preset = "super-tab",

    ["<Tab>"] = {
      function(cmp)
        if cmp.snippet_active() then
          return cmp.accept()
        end

        if cmp.is_visible() then
          return cmp.select_and_accept()
        end

        return false
      end,
      "snippet_forward",
      "fallback",
    },

    ["<Up>"] = {
      hide_completion_after_move,
      "fallback",
    },

    ["<Down>"] = {
      hide_completion_after_move,
      "fallback",
    },
  },

  completion = {
    trigger = {
      show_on_keyword = true,
      show_on_insert = false,
    },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 250,
    },

    ghost_text = {
      enabled = true,
    },
  },

  sources = {
    default = {
      "lsp",
      "path",
      "buffer",
    },
  },

  signature = {
    enabled = true,
  },
})

-- Treesitter highlighting.
-- Parsers themselves are supplied declaratively by Nix.
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "nix",
    "lua",
    "python",
    "c",
    "cpp",
    "sh",
    "json",
    "yaml",
    "markdown",
    "vim",
    "vimdoc",
  },

  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
