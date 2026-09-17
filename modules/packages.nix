{ lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "vscode"
      "steam"
      "steam-original"
      "steam-unwrapped"
    ];
}
