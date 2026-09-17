{ ... }:

{
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;

    interfaces."tailscale0".allowedTCPPorts = [ 22 ];
  };

  services.tailscale = {
    enable = true;

    # Öffnet den Tailscale-UDP-Port für direkte Peer-to-Peer-Verbindungen.
    openFirewall = true;
  };

  services.openssh = {
    enable = true;
    openFirewall = false;
  };
}
