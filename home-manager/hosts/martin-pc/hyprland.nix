{ ... }:

{
  wayland.windowManager.hyprland.extraConfig = ''
    -- Wake displays after DPMS off
    hl.config({
      misc = {
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
      },
    })

    -- Monitors
    -- BenQ: physically left
    hl.monitor({
      output = "HDMI-A-1",
      mode = "1920x1080@60",
      position = "0x0",
      scale = 1,
    })

    -- AOC: physically right / main display
    hl.monitor({
      output = "DP-3",
      mode = "1920x1080@144",
      position = "1920x0",
      scale = 1,
    })

    -- Workspaces 1-5: AOC
    for i = 1, 5 do
      hl.workspace_rule({
        workspace = tostring(i),
        monitor = "DP-3",
        default = (i == 1),
        persistent = true,
      })
    end

    -- Workspaces 6-9: BenQ
    for i = 6, 9 do
      hl.workspace_rule({
        workspace = tostring(i),
        monitor = "HDMI-A-1",
        default = (i == 6),
        persistent = true,
      })
    end
  '';

  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";
      };

      listener = [
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }

        {
          timeout = 900;
          ignore_inhibit = true;
          on-timeout = "if pidof hyprlock >/dev/null; then hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })'; fi";
          on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";
        }
      ];
    };
  };
}
