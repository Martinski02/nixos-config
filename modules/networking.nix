{ ... }:

{
  networking.networkmanager.enable = true;

  # NixOS aktiviert die Firewall standardmäßig; wir deklarieren das explizit.
  networking.firewall.enable = true;
}
