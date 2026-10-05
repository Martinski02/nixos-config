{ lib, hostName, pkgs, ... }:

let
  isLaptop = hostName == "martin-laptop";

  bluetoothStatus = pkgs.writeShellApplication {
    name = "waybar-bluetooth-status";

    runtimeInputs = with pkgs; [
      bluez
      gnugrep
      gnused
      jq
    ];

    text = ''
      set -euo pipefail

      controller="$(bluetoothctl show 2>/dev/null || true)"

      if [ -z "$controller" ]; then
        text="<span size='large'>󰂲</span>"
        class="no-controller"
      elif ! grep -q "Powered: yes" <<< "$controller"; then
        text="<span size='large'>󰂲</span>"
        class="off"
      else
        mapfile -t devices < <(
          bluetoothctl devices Connected 2>/dev/null |
            sed -n 's/^Device [0-9A-Fa-f:]* //p'
        )

        count="''${#devices[@]}"

        if [ "$count" -eq 0 ]; then
          text="<span size='large'></span>"
          class="on"
        else
          alias="''${devices[0]}"

          # Escape the device alias before embedding it in Pango markup.
          alias="$(
            printf '%s' "$alias" |
              sed \
                -e 's/&/\&amp;/g' \
                -e 's/</\&lt;/g' \
                -e 's/>/\&gt;/g'
          )"

          extra=$((count - 1))
          suffix=""

          if [ "$extra" -gt 0 ]; then
            suffix=" + $extra"
          fi

          text="<span size='large'>󰂱</span> $alias$suffix"
          class="connected"
        fi
      fi

      jq -cn \
        --arg text "$text" \
        --arg class "$class" \
        '{text: $text, class: $class}'
    '';
  };
in
{
  home.packages = [
    pkgs.networkmanagerapplet
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";

        # Keep sizing shared for now.
        # PC/laptop scaling is handled as a separate step later.
        height = 34;

        # Symmetric outer spacing. The previous setup only had a
        # top margin, which made the capsules look vertically offset.
        margin-top = 4;
        margin-bottom = 4;
        margin-left = 8;
        margin-right = 8;

        spacing = 0;
        fixed-center = true;

        modules-left = [
          "custom/system"
          "clock"
          "hyprland/window"
        ];

        modules-center = [
          "hyprland/workspaces"
        ];

        modules-right =
          [
            "pulseaudio"
            "custom/bluetooth"
            "network"
            "custom/notification"
          ]
          ++ lib.optionals isLaptop [
            "battery"
          ];

        # ─────────────────────────────────────────────
        # LEFT
        # ─────────────────────────────────────────────

        "custom/system" = {
          format = "<span rise='-1600'></span>";
          escape = false;
          align = 0.5;
          justify = "center";
          tooltip = false;
          on-click = "ghostty -e btop";
        };

        clock = {
          interval = 1;
          format = "{:%H:%M}";

          tooltip-format =
            "<big>{:%A, %d. %B %Y}</big>\n"
            + "<tt><small>{calendar}</small></tt>";
        };

        "hyprland/window" = {
          format = "{title}";
          max-length = 32;
          separate-outputs = true;

          rewrite = {
            "^.*ChatGPT.*Mozilla Firefox$" =
              "ChatGPT · Firefox";

            "^.*YouTube.*Mozilla Firefox$" =
              "YouTube · Firefox";

            "^.*GitHub.*Mozilla Firefox$" =
              "GitHub · Firefox";

            "^((?!ChatGPT|YouTube|GitHub).)*Mozilla Firefox$" =
              "Firefox";
          };
        };

        # ─────────────────────────────────────────────
        # CENTER
        # ─────────────────────────────────────────────

        "hyprland/workspaces" = {
          format = "{name}";

          # Only workspaces belonging to the respective output.
          # No Waybar-side persistent workspaces.
          all-outputs = false;
          active-only = false;
          sort-by = "number";

          disable-scroll = true;
          tooltip = false;

          on-click = "activate";
        };

        # ─────────────────────────────────────────────
        # RIGHT
        # ─────────────────────────────────────────────

        pulseaudio = {
          format = "<span size='large'>{icon}</span> {volume}%";
          format-muted = "<span size='large'>󰝟</span>";

          format-bluetooth =
            "<span size='large'>{icon}</span> {volume}%";
          format-bluetooth-muted =
            "<span size='large'>󰝟</span>";

          format-icons = {
            headphone = "";
            headset = "󰋎";
            hands-free = "󰋎";
            speaker = "󰓃";

            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };

          scroll-step = 5;

          on-click = "pavucontrol";
          on-click-middle =
            "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

          tooltip = false;
        };

        "custom/bluetooth" = {
          exec = "${bluetoothStatus}/bin/waybar-bluetooth-status";
          return-type = "json";
          interval = 2;

          format = "{}";
          escape = false;

          tooltip = false;
          on-click = "blueman-manager";

          max-length = 32;
        };

        network = {
          interval = 5;

          # WLAN keeps signal-strength icon + SSID.
          format-wifi =
            "<span size='large'>{icon}</span>  {essid}";

          # Alternative Ethernet glyph to the previous one.
          format-ethernet =
            "<span size='large'>󰈁</span>";
          format-linked =
            "<span size='large'>󰈁</span>";

          format-disconnected =
            "<span size='large'>󰤭</span>";
          format-disabled =
            "<span size='large'>󰤭</span>";

          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];

          max-length = 24;

          tooltip = false;
          on-click = "nm-connection-editor";
        };

        "custom/notification" = {
          tooltip = false;

          format = "{icon}";

          format-icons = {
            notification = "󱅫";
            none = "󰂜";

            dnd-notification = "󰂠";
            dnd-none = "󰪓";

            inhibited-notification = "󰂛";
            inhibited-none = "󰪑";

            dnd-inhibited-notification = "󰂛";
            dnd-inhibited-none = "󰪑";
          };

          return-type = "json";
          exec = "swaync-client -swb";

          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";

          escape = true;
        };

        battery = {
          interval = 30;

          # Desired semantics:
          #  0-20  -> critical / red
          # 21-60  -> warning  / yellow
          # 61-100 -> normal   / green
          states = {
            warning = 60;
            critical = 20;
          };

          format =
            "<span size='large'>{icon}</span> {capacity}%";
          format-charging =
            "<span size='large'>󰂄</span> {capacity}%";
          format-plugged =
            "<span size='large'>󰂄</span> {capacity}%";
          format-full =
            "<span size='large'>󰁹</span> {capacity}%";

          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];

          tooltip = false;
        };
      };
    };

    style = lib.mkForce ''
      /*
       * Wallpaper-derived palette.
       *
       * Until a real wallpaper has been passed through Pywal,
       * this file contains our Kanagawa fallback colors.
       */
      @import url("file:///home/martin/.cache/wal/waybar.css");

      /*
       * Stable UI colors.
       *
       * Capsule background intentionally does NOT depend on the
       * wallpaper so readability stays predictable.
       */
      @define-color capsule       #1f1f28;
      @define-color capsule_hover #2a2a37;

      @define-color muted         #727169;

      /*
       * Semantic state colors stay fixed.
       */
      @define-color battery_green  #98bb6c;
      @define-color battery_yellow #e6c384;
      @define-color battery_red    #e82424;

      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 14px;

        border: none;
        min-height: 0;

        box-shadow: none;
        text-shadow: none;
      }

      window#waybar {
        background: transparent;
        color: @wal_foreground;
      }

      /*
       * Shared capsules.
       *
       * No vertical module margin anymore: Waybar itself now has
       * symmetric top/bottom margins. This should fix the visual
       * "everything hangs too low" effect.
       */
      #custom-system,
      #clock,
      #window,
      #workspaces,
      #pulseaudio,
      #custom-bluetooth,
      #network,
      #custom-notification,
      #battery {
        background: @capsule;

        margin-left: 4px;
        margin-right: 4px;

        padding-left: 12px;
        padding-right: 12px;

        border-radius: 17px;
      }

      /*
       * LEFT
       */

      #custom-system {
        color: @wal_color12;

        font-size: 18px;
        min-width: 20px;

        /*
         * Fixed symmetric box; only the glyph baseline itself
         * is corrected through Pango above.
         */
        padding-left: 5px;
        padding-right: 10px;

        padding-top: 1px;
        padding-bottom: 0px;
      }

      #custom-system:hover {
        background: @capsule_hover;
      }

      #clock {
        color: @wal_color14;
        font-weight: 600;
      }

      #window {
        color: @wal_foreground;
        font-weight: 500;
      }

      window#waybar.empty #window {
        background: transparent;
        padding: 0;
        margin: 0;
      }

      /*
       * WORKSPACES
       */

      #workspaces {
        padding-left: 5px;
        padding-right: 5px;
      }

      #workspaces button {
        background: transparent;
        color: @wal_foreground;

        padding-left: 9px;
        padding-right: 9px;

        margin-left: 1px;
        margin-right: 1px;

        border-radius: 13px;
      }

      #workspaces button.empty {
        color: @muted;
      }

      /*
       * "active" = globally focused workspace.
       * "visible" = currently visible workspace on another monitor.
       *
       * Both should visually represent the workspace currently
       * displayed on that output.
       */
      #workspaces button.active,
      #workspaces button.visible {
        background: @wal_color12;
        color: #1f1f28;
        font-weight: 700;
      }

      #workspaces button.urgent {
        background: @battery_red;
        color: #1f1f28;
      }

      #workspaces button:hover {
        background: @capsule_hover;
        color: @wal_foreground;
      }

      /*
       * AUDIO
       */

      #pulseaudio {
        color: @wal_color11;
      }

      #pulseaudio.muted {
        color: @muted;
      }

      #pulseaudio:hover {
        background: @capsule_hover;
      }

      /*
       * BLUETOOTH
       */

      #custom-bluetooth {
        color: @wal_color13;
      }

      #custom-bluetooth.connected {
        color: @wal_color13;
      }

      #custom-bluetooth.off,
      #custom-bluetooth.disabled {
        color: @muted;
      }

      #custom-bluetooth:hover {
        background: @capsule_hover;
      }

      /*
       * NETWORK
       */

      #network {
        color: @wal_color14;
      }

      #network.disconnected,
      #network.disabled {
        color: @muted;
      }

      /*
       * NOTIFICATIONS
       */

      #custom-notification {
        color: @wal_color13;
        font-size: 17px;
        min-width: 17px;
      }

      #custom-notification:hover {
        background: @capsule_hover;
      }

      /*
       * BATTERY
       *
       * Order matters: charging/plugged comes after warning/critical
       * so charging always wins and remains green.
       */

      #battery {
        color: @battery_green;
      }

      #battery.warning {
        color: @battery_yellow;
      }

      #battery.critical {
        color: @battery_red;
      }

      #battery.charging,
      #battery.plugged,
      #battery.full {
        color: @battery_green;
      }
    '';
  };
}
