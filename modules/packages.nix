{ lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "vscode"
      "steam"
      "steam-original"
      "steam-unwrapped"
    ];

  nixpkgs.config.allowUnfreePackages = [
    "vscode-extension-MS-python-vscode-pylance"
    "vscode-extension-ms-vscode-remote-remote-ssh"
    "vscode-extension-ms-vscode-remote-remote-ssh-edit"
    "vscode-extension-ms-vscode-remote-explorer"
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
