{ ... }:

{
  programs.ssh.startAgent = true;

  services.openssh = {
    enable = true;
    openFirewall = false;

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [
    22
  ];
}
