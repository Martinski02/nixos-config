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

  cFormatter42 = pkgs.python3Packages.buildPythonApplication rec {
    pname = "c-formatter-42";
    version = "0.2.8";

    pyproject = true;

    build-system = [
      pkgs.python3Packages.setuptools
    ];

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
    ];

    buildInputs = [
      pkgs.stdenv.cc.cc.lib
      pkgs.zlib
      pkgs.ncurses
    ];

    src = pkgs.fetchPypi {
      pname = "c_formatter_42";
      inherit version;
      hash = "sha256-2jGxq0zckt02OueRJEzwY5guKcn8VNveDyL84gorBXs=";
    };

    doCheck = false;
  };
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins =
      (with pkgs.vimPlugins; [
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
      ripgrep
      fd

      nixd
      lua-language-server
      basedpyright
      clang-tools
      bash-language-server

      nixfmt
      stylua
      black
      shfmt

      # 42
      norminette
      cFormatter42
    ];

    initLua = builtins.readFile ./neovim/init.lua;
  };

  xdg.configFile."nvim/lua".source = ./neovim/lua;
}
