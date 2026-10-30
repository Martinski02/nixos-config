{ pkgs, ... }:

let
  chatgpt = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "openai";
      name = "chatgpt";
      version = "26.727.40816";
      arch = "linux-x64";
      hash = "sha256-QwkU7y9s9fRzFf2xDmOrGKPLe2b+RzYZB7nzXrkLD6g=";
    };
  };
in
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;

    profiles.default = {
      extensions =
        (with pkgs.vscode-extensions; [
          ms-python.python
          ms-python.vscode-pylance
          ms-python.debugpy
          ms-python.vscode-python-envs

          ms-vscode-remote.remote-ssh
          ms-vscode-remote.remote-ssh-edit
          ms-vscode.remote-explorer
        ])
        ++ [ chatgpt ];

      userSettings = {
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
  };
}
