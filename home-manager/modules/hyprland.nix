{ pkgs, ... }:

let
  screenshotFull = pkgs.writeShellApplication {
    name = "screenshot-full";

    runtimeInputs = with pkgs; [
      coreutils
      grim
      libnotify
      util-linux
    ];

    text = ''
      set -euo pipefail

      if ! mountpoint -q /mnt/data; then
        notify-send "Screenshot not saved" "/mnt/data is not mounted." || true
        exit 1
      fi

      target="$HOME/pictures/screenshots"
      mkdir -p "$target"

      file="$target/$(date '+%Y-%m-%d_%H-%M-%S').png"

      grim "$file"

      notify-send "Screenshot saved" "$file" || true
    '';
  };

  screenshotRegion = pkgs.writeShellApplication {
    name = "screenshot-region";

    runtimeInputs = with pkgs; [
      coreutils
      grim
      libnotify
      slurp
      util-linux
    ];

    text = ''
      set -euo pipefail

      if ! mountpoint -q /mnt/data; then
        notify-send "Screenshot not saved" "/mnt/data is not mounted." || true
        exit 1
      fi

      geometry="$(slurp)" || exit 0

      if [ -z "$geometry" ]; then
        exit 0
      fi

      target="$HOME/pictures/screenshots"
      mkdir -p "$target"

      file="$target/$(date '+%Y-%m-%d_%H-%M-%S').png"

      grim -g "$geometry" "$file"

      notify-send "Screenshot saved" "$file" || true
    '';
  };
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    # Hyprland and its portal are installed system-wide by NixOS.
    package = null;
    portalPackage = null;

    # UWSM owns the graphical systemd session.
    systemd.enable = false;

    configType = "lua";

    extraConfig = ''
      local mainMod = "SUPER"

      hl.config({
        general = {
          layout = "dwindle",
          gaps_in = 6,
          gaps_out = 8,
          border_size = 2,
        },

        decoration = {
          rounding = 6,
        },

        input = {
          follow_mouse = 0,
        },

        animations = {
          enabled = true,
        },
      })

      -- Applications
      hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("ghostty"))
      hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("fuzzel"))

      -- Window management
      hl.bind(mainMod .. " + Q", hl.dsp.window.close())
      hl.bind(
        mainMod .. " + F",
        hl.dsp.window.fullscreen({
          mode = "fullscreen",
          action = "toggle",
        })
      )
      hl.bind(
        mainMod .. " + V",
        hl.dsp.window.float({
          action = "toggle",
        })
      )

      -- Focus
      hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "l" }))
      hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
      hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "u" }))
      hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "d" }))

      -- Move tiled windows
      hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "l" }))
      hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
      hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "u" }))
      hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "d" }))

      -- Workspaces 1-9
      for i = 1, 9 do
        local key = tostring(i)

        hl.bind(
          mainMod .. " + " .. key,
          hl.dsp.focus({ workspace = i })
        )

        hl.bind(
          mainMod .. " + SHIFT + " .. key,
          hl.dsp.window.move({
            workspace = i,
            follow = true,
          })
        )
      end

      -- Monitor navigation
      hl.bind(
        mainMod .. " + CTRL + left",
        hl.dsp.focus({ monitor = "l" })
      )

      hl.bind(
        mainMod .. " + CTRL + right",
        hl.dsp.focus({ monitor = "r" })
      )

      hl.bind(
        mainMod .. " + CTRL + SHIFT + left",
        hl.dsp.window.move({
          monitor = "l",
          follow = true,
        })
      )

      hl.bind(
        mainMod .. " + CTRL + SHIFT + right",
        hl.dsp.window.move({
          monitor = "r",
          follow = true,
        })
      )

      -- Mouse move / resize
      hl.bind(
        mainMod .. " + mouse:272",
        hl.dsp.window.drag(),
        { mouse = true }
      )

      hl.bind(
        mainMod .. " + mouse:273",
        hl.dsp.window.resize(),
        { mouse = true }
      )

      -- Desktop shell
      hl.bind(
        mainMod .. " + N",
        hl.dsp.exec_cmd("swaync-client -t -sw")
      )

      hl.bind(
        mainMod .. " + SHIFT + Q",
        hl.dsp.exec_cmd("wlogout")
      )

      -- Screenshots
      hl.bind(
        "PRINT",
        hl.dsp.exec_cmd("${screenshotFull}/bin/screenshot-full")
      )

      hl.bind(
        mainMod .. " + PRINT",
        hl.dsp.exec_cmd("${screenshotRegion}/bin/screenshot-region")
      )

      -- Clipboard history
      hl.bind(
        mainMod .. " + SHIFT + V",
        hl.dsp.exec_cmd(
          "${pkgs.cliphist}/bin/cliphist list"
          .. " | ${pkgs.fuzzel}/bin/fuzzel --dmenu"
          .. " | ${pkgs.cliphist}/bin/cliphist decode"
          .. " | ${pkgs.wl-clipboard}/bin/wl-copy"
        )
      )
    '';
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [
          "hyprland/window"
        ];

        modules-right = [
          "tray"
          "network"
          "pulseaudio"
          "clock"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
        };

        "hyprland/window" = {
          max-length = 80;
        };

        tray = {
          spacing = 8;
        };

        network = {
          format-wifi = "{essid} {signalStrength}%";
          format-ethernet = "Ethernet";
          format-disconnected = "Offline";
          tooltip = true;
        };

        pulseaudio = {
          format = "{volume}%";
          format-muted = "Muted";
          scroll-step = 5;
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%A, %d.%m.%Y}";
          tooltip-format = "<tt>{calendar}</tt>";
        };
      };
    };
  };

  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        terminal = "ghostty";
        layer = "overlay";
        width = 40;
        lines = 12;
      };
    };
  };

  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "300, 50";
          position = "0, -80";
          dots_center = true;
          fade_on_empty = false;
          placeholder_text = "<i>Passwort...</i>";
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }

        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  services.hyprpaper.enable = true;

  services.swaync = {
    enable = true;

    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;

      notification-icon-size = 48;
      notification-body-image-height = 100;
      notification-body-image-width = 200;

      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
    };
  };

  home.packages = with pkgs; [
    screenshotFull
    screenshotRegion

    grim
    slurp
    swappy
    cliphist
    wlogout
    hyprpolkitagent
  ];

  systemd.user.services.cliphist-text = {
    Unit = {
      Description = "Cliphist text clipboard watcher";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
    };

    Install.WantedBy = [
      "graphical-session.target"
    ];
  };

  systemd.user.services.cliphist-image = {
    Unit = {
      Description = "Cliphist image clipboard watcher";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
    };

    Install.WantedBy = [
      "graphical-session.target"
    ];
  };

  systemd.user.services.hyprpolkitagent = {
    Unit = {
      Description = "Hyprland Polkit authentication agent";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
    };

    Install.WantedBy = [
      "graphical-session.target"
    ];
  };
}
