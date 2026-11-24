{ config, lib, pkgs, ... }:

let
  home = config.home.homeDirectory;
in
{
  xdg.userDirs = {
    enable = true;
    createDirectories = false;

    desktop = "${home}/Desktop";
    download = "${home}/Downloads";
    documents = "${home}/Documents";
    pictures = "${home}/Pictures";
    videos = "${home}/Videos";

    music = home;
    publicShare = home;
    templates = home;

    extraConfig = {
      PROJECTS = "${home}/Development/projects";
    };
  };

  home.activation.createSharedDirectories =
    lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      run ${pkgs.coreutils}/bin/mkdir -p -- \
        "${home}/Desktop" \
        "${home}/Development/projects" \
        "${home}/Downloads" \
        "${home}/Inbox" \
        "${home}/Tmp"
    '';
}
