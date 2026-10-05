{ config, lib, pkgs, ... }:

let
  themeFromWallpaper = pkgs.writeShellApplication {
    name = "theme-from-wallpaper";

    runtimeInputs = with pkgs; [
      pywal16
      hyprland
      jq
      procps
    ];

    text = ''
      set -euo pipefail

      if [ "$#" -gt 1 ]; then
        echo "Usage: theme-from-wallpaper [wallpaper]" >&2
        exit 2
      fi

      if [ "$#" -eq 1 ]; then
        wallpaper="$1"
      else
        monitor="$(
          hyprctl -j monitors |
            jq -r '.[] | select(.focused == true) | .name' |
            head -n 1
        )"

        if [ -z "$monitor" ]; then
          echo "Could not determine focused monitor." >&2
          exit 1
        fi

        wallpaper=""

        while IFS= read -r line; do
          case "$line" in
            "$monitor: "*)
              wallpaper="''${line#"$monitor: "}"
              break
              ;;
          esac
        done < <(hyprctl hyprpaper listactive)

        if [ -z "$wallpaper" ]; then
          echo "Could not determine wallpaper for monitor: $monitor" >&2
          exit 1
        fi
      fi

      if [ ! -f "$wallpaper" ]; then
        echo "Wallpaper does not exist: $wallpaper" >&2
        exit 1
      fi

      echo "Generating palette from:"
      echo "  $wallpaper"

      wal \
        --cols16 \
        -n \
        -s \
        -t \
        -e \
        -q \
        -i "$wallpaper"

      if pgrep -x waybar >/dev/null; then
        pkill -SIGUSR2 waybar
      fi

      echo
      echo "Theme palette updated."
    '';
  };
in
{
  home.packages = [
    pkgs.pywal16
    themeFromWallpaper
  ];

  xdg.configFile."wal/templates/waybar.css".source =
    ./templates/waybar.css;

  # Waybar must also work before Pywal has ever generated a palette
  # or after ~/.cache has been cleared.
  home.activation.themePaletteFallback =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      cache_dir="${config.xdg.cacheHome}/wal"
      palette="$cache_dir/waybar.css"

      mkdir -p "$cache_dir"

      if [ ! -e "$palette" ]; then
        cat > "$palette" <<'CSS'
@define-color wal_background #1f1f28;
@define-color wal_foreground #dcd7ba;

@define-color wal_color0  #16161d;
@define-color wal_color1  #e82424;
@define-color wal_color2  #98bb6c;
@define-color wal_color3  #e6c384;
@define-color wal_color4  #7e9cd8;
@define-color wal_color5  #957fb8;
@define-color wal_color6  #7fb4ca;
@define-color wal_color7  #dcd7ba;

@define-color wal_color8  #727169;
@define-color wal_color9  #e46876;
@define-color wal_color10 #98bb6c;
@define-color wal_color11 #e6c384;
@define-color wal_color12 #7fb4ca;
@define-color wal_color13 #938aa9;
@define-color wal_color14 #7aa89f;
@define-color wal_color15 #c8c093;
CSS
      fi
    '';
}
