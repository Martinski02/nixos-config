{ ... }:

{
  imports = [
     ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/networking.nix
    ../../modules/ssh.nix
    ../../modules/hyprland.nix
    ../../modules/development.nix
    ../../modules/gaming.nix
    ../../modules/packages.nix

    ./base.nix
    ./networking.nix
    ./ssh.nix
    ./hyprland.nix
    ./development.nix
    ./gaming.nix
    ./packages.nix
    ./backup.nix
  ];

  networking.hostName = "martin-pc";
}
