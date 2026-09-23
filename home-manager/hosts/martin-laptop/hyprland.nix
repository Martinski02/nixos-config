{ ... }:

{
  wayland.windowManager.hyprland.extraConfig = ''
    -- Internal laptop display
    hl.monitor({
      output = "eDP-1",
      mode = "1920x1200@60",
      position = "0x0",
      scale = 1,
    })

    -- Laptop input
    hl.config({
      input = {
        touchpad = {
          tap_to_click = true,
          natural_scroll = false,
          disable_while_typing = true,
        },
      },
    })

    -- Laptop function keys: audio
    hl.bind("XF86AudioMute", hl.dsp.exec_cmd(
      "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ))
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(
      "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ))
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(
      "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
    ))
    hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(
      "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ))

    -- Laptop function keys: display brightness
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(
      "brightnessctl set 5%-"
    ))
    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(
      "brightnessctl set 5%+"
    ))

    -- Laptop lock key (F10 emits Super+L)
    hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"))
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
          # Lock after 10 minutes of inactivity.
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }

        {
          # On battery, turn the display off after 10 minutes.
          timeout = 600;
          on-timeout = "if [ \"$(cat /sys/class/power_supply/ACAD/online)\" = \"0\" ]; then hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })'; fi";
          on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";
        }

        {
          # On battery, suspend after 60 minutes of inactivity.
          timeout = 3600;
          on-timeout = "if [ \"$(cat /sys/class/power_supply/ACAD/online)\" = \"0\" ]; then systemctl suspend; fi";
        }
      ];
    };
  };
}
