{ pkgs, ... }:

let
  header42 = pkgs.vimUtils.buildVimPlugin {
    pname = "42header";
    version = "8ccddfe";

    src = pkgs.fetchFromGitHub {
      owner = "42Paris";
      repo = "42header";
      rev = "8ccddfe98127e2f90b7ddf91512224f554fd79b2";
      hash = "sha256-waAi4BfTulro6Pvs2xPsW7RrMhggt+OBwy5FAoUYGTs=";
    };
  };
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = (with pkgs.vimPlugins; [
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
    ])
    ++ [
        header42
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

      # 42
      norminette
    ];

    initLua = builtins.readFile ./neovim/init.lua;
  };

  xdg.configFile."nvim/lua".source = ./neovim/lua;
}
