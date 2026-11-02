{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    nextcloud-client
    vim
    tree
    wl-clipboard
  ];
}
