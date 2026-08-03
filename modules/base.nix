{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-c8c509f3-bcb2-47c2-8cff-6fa91a0d5dcc".device =
    "/dev/disk/by-uuid/c8c509f3-bcb2-47c2-8cff-6fa91a0d5dcc";

  networking.hostName = "nixos";

  time.timeZone = "Europe/Vienna";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  console.keyMap = "de";

  users.users.martin = {
    isNormalUser = true;
    description = "Martin Barbier";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Firefox currently renders incorrectly with its native Wayland backend.
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "0";
}
