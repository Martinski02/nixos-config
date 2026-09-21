{ pkgs, ... }:

let
  normalRgb = "0000FF";

  rgbOff = pkgs.writeShellApplication {
    name = "rgb-off";

    runtimeInputs = with pkgs; [
      openrgb
    ];

    text = ''
      set -euo pipefail

      openrgb \
        --client 127.0.0.1:6742 \
        --device "ASUS TUF GAMING B850-PLUS WIFI" \
        --mode Off

      openrgb \
        --client 127.0.0.1:6742 \
        --device "SteelSeries Apex Pro TKL Gen 3 Wired" \
        --mode Direct \
        --color 000000
    '';
  };

  rgbOn = pkgs.writeShellApplication {
    name = "rgb-on";

    runtimeInputs = with pkgs; [
      openrgb
    ];

    text = ''
      set -euo pipefail

      openrgb \
        --client 127.0.0.1:6742 \
        --device "ASUS TUF GAMING B850-PLUS WIFI" \
        --mode Static \
        --color ${normalRgb}

      openrgb \
        --client 127.0.0.1:6742 \
        --device "SteelSeries Apex Pro TKL Gen 3 Wired" \
        --mode Direct \
        --color ${normalRgb}
    '';
  };

  nightMode = pkgs.writeShellApplication {
    name = "night-mode";

    runtimeInputs = [
      pkgs.coreutils
      pkgs.hyprland
      rgbOff
      rgbOn
    ];

    text = ''
      set -euo pipefail

      case "''${1:-}" in
        on)
          rgb-off

          # Let the key event that launched this command finish before
          # enabling DPMS-off, otherwise it can immediately wake again.
          sleep 2

          hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })'
          ;;

        off)
          hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'
          rgb-on
          ;;

        *)
          echo "Usage: night-mode {on|off}" >&2
          exit 2
          ;;
      esac
    '';
  };
in
{
  home.packages = [
    rgbOff
    rgbOn
    nightMode
  ];
}
