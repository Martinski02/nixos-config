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
          tap-to-click = true,
          natural_scroll = false,
          disable_while_typing = true,
        },
      },
    })
  '';
}
