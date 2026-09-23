{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/base.nix
    ../../modules/networking.nix
    ../../modules/ssh.nix
    ../../modules/development.nix
    ../../modules/packages.nix

    ./base.nix
    ./networking.nix
    ./ssh.nix
    ./hyprland.nix
    ./gaming.nix
    ./development.nix
    ./hardware-extra.nix
    ./packages.nix
    ./backup.nix
  ];

  networking.hostName = "martin-pc";
}
