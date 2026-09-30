{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      kanagawa-nvim

      nvim-web-devicons
      which-key-nvim

      nvim-tree-lua

      plenary-nvim
      telescope-nvim

      lualine-nvim

      nvim-treesitter.withAllGrammars
      nvim-autopairs

      gitsigns-nvim

      nvim-lspconfig
      blink-cmp

      conform-nvim
    ];

    extraPackages = with pkgs; [
      # Search / navigation
      ripgrep
      fd

      # Language servers
      nixd
      lua-language-server
      basedpyright
      clang-tools
      bash-language-server

      # Formatters
      nixfmt
      stylua
      black
      shfmt
    ];

    initLua = builtins.readFile ./neovim/init.lua;
  };

  xdg.configFile."nvim/lua".source = ./neovim/lua;
}
