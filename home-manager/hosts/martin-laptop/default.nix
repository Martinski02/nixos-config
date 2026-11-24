{ config, lib, pkgs, ... }:

let
  home = config.home.homeDirectory;
in
{
  imports = [
    ../../modules/hyprland.nix
    ../../modules/waybar.nix
    ./hyprland.nix
  ];

  home.activation.createLaptopDataDirectories =
    lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      run ${pkgs.coreutils}/bin/mkdir -p -- \
        "${home}/Documents" \
        "${home}/Pictures" \
        "${home}/Videos" \
        "${home}/Nextcloud"
    '';
}
