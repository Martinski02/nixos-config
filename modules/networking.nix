{ pkgs, ... }:

{
  networking.networkmanager.enable = true;

  networking.firewall.enable = true;

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

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
}
