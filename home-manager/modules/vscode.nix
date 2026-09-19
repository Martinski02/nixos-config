{ ... }:

{
  programs.vscode = {
    enable = true;

    profiles.default.userSettings = {
      "[python]" = {
        "diffEditor.ignoreTrimWhitespace" = false;
        "editor.defaultColorDecorators" = "never";
        "editor.formatOnType" = true;
        "editor.wordBasedSuggestions" = "off";
      };

      "explorer.confirmDelete" = false;
      "editor.fontSize" = 16;
      "workbench.startupEditor" = "none";

      "chatgpt.followUpQueueMode" = "steer";
      "chatgpt.composerEnterBehavior" = "cmdAlways";
    };
  };
}
