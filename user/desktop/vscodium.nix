{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      arcticicestudio.nord-visual-studio-code
      bbenoist.nix
    ];
    userSettings = {
      "editor.fontFamily" = "${config.font},Hack Nerd Font";
      "editor.fontSize" = 12;
      "editor.minimap.enabled" = false;
      "editor.tabSize" = 2;
      "files.trimTrailingWhitespace" = true;
      "window.titleBarStyle" = "custom";
      "workbench.colorTheme" = "Nord";
    };
  };
}