{ pkgs, ... }:

{
  home.packages = with pkgs; [
    opencode
    python3
    gcc
    gnumake
    pkg-config
    norminette
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
