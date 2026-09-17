{ pkgs, ... }:

{
  programs.firefox.enable = true;

  home.packages = with pkgs; [
    nextcloud-client
    onlyoffice-desktopeditors
    pavucontrol
    tree
    wl-clipboard

    kdePackages.dolphin
    kdePackages.ark
    kdePackages.kio-extras
  ];
}
