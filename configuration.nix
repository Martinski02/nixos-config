{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/base.nix
    ./modules/desktop-plasma.nix
    ./modules/networking.nix
    ./modules/packages.nix
    ./modules/development.nix
  ];

  # Nicht auf spätere NixOS-Versionen ändern.
  system.stateVersion = "26.05";
}
