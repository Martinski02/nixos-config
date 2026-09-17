{ hostName, ... }:

{
  imports = [
    ./modules/base.nix
    ./modules/desktop.nix
    ./modules/development.nix
    ./modules/gaming.nix
    ./modules/git.nix
    ./modules/ssh.nix
    ./modules/neovim.nix
    ./modules/ghostty.nix
    ./modules/vscode.nix
    ./modules/hyprland.nix

    ./hosts/${hostName}/default.nix
  ];

  home = {
    username = "martin";
    homeDirectory = "/home/martin";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
