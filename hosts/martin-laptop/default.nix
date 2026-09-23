{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/base.nix
    ../../modules/networking.nix
    ../../modules/bluetooth.nix
    ../../modules/ssh.nix
    ../../modules/development.nix
    ../../modules/packages.nix

    ./base.nix
    ./hyprland.nix
    ./hardware-extra.nix
  ];

  networking.hostName = "martin-laptop";
}
