{ pkgs, ... }:

{
  services.xserver = {
    enable = true;

    xkb = {
      layout = "de";
      variant = "";
    };
  };

  services.displayManager.sddm.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  security.rtkit.enable = true;

  services.gnome = {
    gnome-keyring.enable = true;
    gcr-ssh-agent.enable = false;
  };

  security.pam.services = {
    hyprlock = { };
    sddm.enableGnomeKeyring = true;
  };

  services.pipewire = {
    enable = true;

    alsa = {
      enable = true;
      support32Bit = true;
    };

    pulse.enable = true;
  };
}
