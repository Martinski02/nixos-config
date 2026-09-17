{ ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users.martin = {
    isNormalUser = true;
    home = "/home/martin";
    extraGroups = [
      "wheel"
    ];
  };

  system.stateVersion = "26.05";
}
