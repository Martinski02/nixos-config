{ ... }:

{
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  services.tailscale = {
    enable = true;

    # Öffnet den Tailscale-UDP-Port für direkte Peer-to-Peer-Verbindungen.
    openFirewall = true;
  };
}
