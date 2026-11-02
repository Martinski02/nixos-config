{ pkgs, ... }:

let
  normalRgb = "0000FF";

  mainboardDevice = "ASUS TUF GAMING B850-PLUS WIFI";
  keyboardDevice = "SteelSeries Apex Pro TKL Gen 3 Wired";

  rgb = pkgs.writeShellApplication {
    name = "rgb";

    runtimeInputs = with pkgs; [
      coreutils
      openrgb
    ];

    text = ''
      set -euo pipefail

      state_dir="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/rgb-mode"
      state_file="$state_dir/state"

      write_state() {
        mkdir -p "$state_dir"
        printf '%s\n' "$1" > "$state_file"
      }

      read_state() {
        if [ -r "$state_file" ]; then
          state="$(cat "$state_file")"

          case "$state" in
            on|off)
              printf '%s\n' "$state"
              ;;
            *)
              printf '%s\n' "on"
              ;;
          esac
        else
          printf '%s\n' "on"
        fi
      }

      apply_on() {
        openrgb \
          --client 127.0.0.1:6742 \
          --device "${mainboardDevice}" \
          --mode Static \
          --color "${normalRgb}"

        openrgb \
          --client 127.0.0.1:6742 \
          --device "${keyboardDevice}" \
          --mode Direct \
          --color "${normalRgb}"
      }

      apply_off() {
        openrgb \
          --client 127.0.0.1:6742 \
          --device "${mainboardDevice}" \
          --mode Off

        openrgb \
          --client 127.0.0.1:6742 \
          --device "${keyboardDevice}" \
          --mode Direct \
          --color 000000
      }

      apply_state() {
        case "$1" in
          on)
            apply_on
            ;;
          off)
            apply_off
            ;;
          *)
            echo "Invalid RGB state: $1" >&2
            exit 1
            ;;
        esac
      }

      case "''${1:-}" in
        on)
          write_state on
          apply_on
          ;;

        off)
          write_state off
          apply_off
          ;;

        reapply)
          apply_state "$(read_state)"
          ;;

        status)
          state="$(read_state)"

          if [ -r "$state_file" ]; then
            echo "$state"
          else
            echo "$state (default)"
          fi
          ;;

        *)
          echo "Usage: rgb {on|off|status|reapply}" >&2
          exit 2
          ;;
      esac
    '';
  };
in
{
  home.packages = [
    rgb
  ];

  systemd.user.services.rgb-restore = {
    Unit = {
      Description = "Restore default RGB state at graphical login";
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${rgb}/bin/rgb reapply";
    };

    Install.WantedBy = [
      "graphical-session.target"
    ];
  };
}
