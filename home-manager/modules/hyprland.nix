{ pkgs, ... }:

{
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
