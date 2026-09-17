{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    samba
    nextcloud-client
    vim
    tree
    wl-clipboard
  ];
}
