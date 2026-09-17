{ ... }:

{
  programs.ssh.startAgent = true;

  services.openssh = {
    enable = true;
    openFirewall = false;
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [
    22
  ];
}
