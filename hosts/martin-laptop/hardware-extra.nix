{ pkgs, ... }:

{
  services.udisks2.enable = true;
  services.upower.enable = true;
  services.fwupd.enable = true;
  services.power-profiles-daemon.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
  };
  security.wrappers.btop = {
    source = "${pkgs.btop}/bin/btop";
    owner = "root";
    group = "root";
    capabilities = "cap_perfmon+ep";
  };
}
