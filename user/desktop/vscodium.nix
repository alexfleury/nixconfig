{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        #arcticicestudio.nord-visual-studio-code
        arrterian.nix-env-selector
        bbenoist.nix
        ms-python.python
      ];
      userSettings = {
        "editor.autoClosingBrackets" = "never";
        #"editor.fontFamily" = "${config.font},Hack Nerd Font";
        "editor.fontSize" = 12;
        "editor.minimap.enabled" = false;
        "editor.tabSize" = 2;
        "files.trimTrailingWhitespace" = true;
        "window.titleBarStyle" = "custom";
        "workbench.colorTheme" = "Nord";
        "[python]" = {
          "editor.tabSize" = 4;
        };
      };
    };
  };
}
