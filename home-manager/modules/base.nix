{ ... }:

{
  programs.bash.enable = true;

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      auto_sync = false;
      update_check = false;
      secrets_filter = true;
    };
  };
}
