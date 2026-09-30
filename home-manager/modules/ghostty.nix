{ ... }:

{
  programs.ghostty = {
    enable = true;

    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;

      theme = "Kanagawa Wave";

      background = "1c1c1c";
      background-opacity = 0.75;
      background-blur = true;

      clipboard-paste-protection = false;

      keybind = [
        "ctrl+tab=next_tab"
        "ctrl+shift+tab=previous_tab"
      ];
    };
  };
}
