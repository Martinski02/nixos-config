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
}
