{ config, pkgs, ... }:

{
  imports = [
    ../../modules/gaming.nix
    ../../modules/hyprland.nix

    ./hyprland.nix
    ./night-mode.nix
  ];

  programs.btop.package = pkgs.btop-rocm;

  home.file = {
    "documents".source =
      config.lib.file.mkOutOfStoreSymlink "/mnt/data/media/documents";

    "pictures".source =
      config.lib.file.mkOutOfStoreSymlink "/mnt/data/media/pictures";

    "videos".source =
      config.lib.file.mkOutOfStoreSymlink "/mnt/data/media/videos";

    "games".source =
      config.lib.file.mkOutOfStoreSymlink "/mnt/data/games";

    "nextcloud".source =
      config.lib.file.mkOutOfStoreSymlink "/mnt/data/media/documents/nextcloud";
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = false;

    documents = "${config.home.homeDirectory}/documents";
    pictures = "${config.home.homeDirectory}/pictures";
    videos = "${config.home.homeDirectory}/videos";
  };
}
