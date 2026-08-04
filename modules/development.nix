{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "vscode"
    ];

  environment.systemPackages = with pkgs; [
    vscode
    python3
    gcc
    gnumake
    pkg-config
    direnv
    nix-direnv
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
