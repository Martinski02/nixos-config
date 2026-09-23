{ pkgs, ... }:

{
  system.stateVersion = "26.05";

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-c8c509f3-bcb2-47c2-8cff-6fa91a0d5dcc".device =
    "/dev/disk/by-uuid/c8c509f3-bcb2-47c2-8cff-6fa91a0d5dcc";

  # Existing laptop workaround. Re-evaluate after Hyprland is working.
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "0";
}
