{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        arrterian.nix-env-selector
        bbenoist.nix
        ms-python.python
      ];
      userSettings = {
        "editor.autoClosingBrackets" = "never";
        "editor.autoClosingDelete" = "never";
        "editor.autoClosingOvertype" = "never";
        "editor.minimap.enabled" = false;
        "editor.tabSize" = 2;
        "files.trimTrailingWhitespace" = true;
        "window.titleBarStyle" = "custom";
        "[python]" = {
          "editor.tabSize" = 4;
          "editor.rulers" = [ 72 80 ];
        };
      };
    };
  };

  stylix.targets.vscode.profileNames = [ "default" ];
}
