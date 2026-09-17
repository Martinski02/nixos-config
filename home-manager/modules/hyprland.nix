{ pkgs, ... }:

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
  };

  programs.fuzzel.enable = true;

  programs.hyprlock.enable = true;

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

  services.swaync.enable = true;

  home.packages = with pkgs; [
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
