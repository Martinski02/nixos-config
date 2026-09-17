{ pkgs, ... }:

{
  programs.mangohud.enable = true;

  home.packages = with pkgs; [
    prismlauncher
    protonup-qt
  ];
}
