{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/base.nix
    ./modules/desktop-plasma.nix
    ./modules/networking.nix
    ./modules/packages.nix
    ./modules/development.nix
  ];

  # Samba-Share von martin-server.
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  fileSystems."/mnt/martin-server-shares" = {
    device = "//martin-server/shares";
    fsType = "cifs";
    options = [
      "credentials=/home/martin/.config/samba/martin-server-credentials"
      "uid=1000"
      "gid=100"
      "iocharset=utf8"
      "_netdev"
      "nofail"
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
    ];
  };

  # Nicht auf spätere NixOS-Versionen ändern.
  system.stateVersion = "26.05";
}
