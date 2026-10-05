{ lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "vscode"
      "steam"
      "steam-original"
      "steam-unwrapped"
    ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
