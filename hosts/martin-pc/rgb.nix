{ pkgs, ... }:

{
  systemd.services.rgb-keyboard-recover = {
    description = "Recover OpenRGB after SteelSeries keyboard reconnect";

    after = [
      "openrgb.service"
    ];

    serviceConfig = {
      Type = "oneshot";
    };

    script = ''
      set -euo pipefail

      # Let the keyboard and its HID interfaces finish enumerating.
      ${pkgs.coreutils}/bin/sleep 2

      # OpenRGB keeps a stale controller after a USB reconnect.
      # Restarting the SDK server forces clean device discovery.
      ${pkgs.systemd}/bin/systemctl restart openrgb.service

      # Give OpenRGB time to rediscover all RGB controllers.
      ${pkgs.coreutils}/bin/sleep 3

      # Restore the RGB state selected by the user (on/off).
      ${pkgs.util-linux}/bin/runuser \
        -u martin \
        -- /etc/profiles/per-user/martin/bin/rgb reapply
    '';
  };

  services.udev.extraRules = ''
    # SteelSeries Apex Pro TKL Gen 3 Wired (1038:1642)
    # Match only the top-level USB device, not its five HID interfaces.
    ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="1038", ATTR{idProduct}=="1642", TAG+="systemd", ENV{SYSTEMD_WANTS}+="rgb-keyboard-recover.service"
  '';
}
