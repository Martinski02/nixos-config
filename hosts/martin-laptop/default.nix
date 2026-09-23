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
    ./desktop-plasma.nix
  ];

  networking.hostName = "martin-laptop";
}
