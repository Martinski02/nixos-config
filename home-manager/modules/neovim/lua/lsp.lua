-- Lua: understand Neovim's own runtime when editing config files.
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
        },
        checkThirdParty = false,
      },

      telemetry = {
        enable = false,
      },
    },
  },
})

local servers = {
  "nixd",
  "lua_ls",
  "basedpyright",
  "clangd",
  "bashls",
}

for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end
