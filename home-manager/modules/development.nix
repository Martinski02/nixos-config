{ pkgs, ... }:

{
  home.packages = with pkgs; [
    opencode
    python3
    gcc
    gnumake
    pkg-config
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
