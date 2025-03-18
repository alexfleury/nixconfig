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
        "editor.minimap.enabled" = false;
        "editor.tabSize" = 2;
        "files.trimTrailingWhitespace" = true;
        "window.titleBarStyle" = "custom";
        "[python]" = {
          "editor.tabSize" = 4;
        };
      };
    };
  };

  stylix.targets.vscode.profileNames = [ "default" ];
}
