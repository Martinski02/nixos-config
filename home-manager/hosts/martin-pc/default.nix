{ config, pkgs, ... }:

{
  imports = [
    ../../modules/gaming.nix
    ../../modules/hyprland.nix
    ../../modules/waybar.nix

    ./hyprland.nix
    ./rgb.nix
  ];

  programs.btop.package = pkgs.btop-rocm;

  home.file = {
    "Documents".source =
      config.lib.file.mkOutOfStoreSymlink "/mnt/data/media/documents";

    "Pictures".source =
      config.lib.file.mkOutOfStoreSymlink "/mnt/data/media/pictures";

    "Videos".source =
      config.lib.file.mkOutOfStoreSymlink "/mnt/data/media/videos";

    "Games".source =
      config.lib.file.mkOutOfStoreSymlink "/mnt/data/games";

    "Nextcloud".source =
      config.lib.file.mkOutOfStoreSymlink "/mnt/data/media/documents/nextcloud";
  };
}
