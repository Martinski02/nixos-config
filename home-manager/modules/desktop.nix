{ pkgs, ... }:

{
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "application/pdf" = "firefox.desktop";

      "inode/directory" = "org.kde.dolphin.desktop";

      "application/msword" = "onlyoffice-desktopeditors.desktop";
      "application/vnd.ms-excel" = "onlyoffice-desktopeditors.desktop";
      "application/vnd.ms-powerpoint" = "onlyoffice-desktopeditors.desktop";

      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" =
        "onlyoffice-desktopeditors.desktop";
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" =
        "onlyoffice-desktopeditors.desktop";
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" =
        "onlyoffice-desktopeditors.desktop";

      "application/vnd.oasis.opendocument.text" =
        "onlyoffice-desktopeditors.desktop";
      "application/vnd.oasis.opendocument.spreadsheet" =
        "onlyoffice-desktopeditors.desktop";
      "application/vnd.oasis.opendocument.presentation" =
        "onlyoffice-desktopeditors.desktop";
    };
  };

  programs.firefox.enable = true;

  programs.btop = {
    enable = true;

    settings = {
      shown_boxes = "cpu mem net proc gpu0";
      show_gpu_info = "Off";
    };
  };

  home.packages = with pkgs; [
    nextcloud-client
    onlyoffice-desktopeditors
    pavucontrol
    tree
    wl-clipboard

    kdePackages.dolphin
    kdePackages.ark
    kdePackages.kio-extras
  ];
}
