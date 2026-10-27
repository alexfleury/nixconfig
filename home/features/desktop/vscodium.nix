{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.vscodium;
in {
  options.features.desktop.vscodium.enable = mkEnableOption "enable codium";

  config = mkIf cfg.enable {
    programs.vscodium = {
      enable = true;
      mutableExtensionsDir = false;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          ms-python.python
        ];
        userSettings = {
          "editor.autoClosingBrackets" = "never";
          "editor.autoClosingDelete" = "never";
          "editor.autoClosingOvertype" = "never";
          "editor.autoClosingQuotes" = "never";
          "editor.autoSurround" = "never";
          "editor.guides.bracketPairsHorizontal" = false;
          "editor.matchBrackets" = "near";
          "editor.minimap.enabled" = false;
          "editor.tabSize" = 2;
          "extensions.autoUpdate" = "off";
          "files.trimTrailingWhitespace" = true;
          "window.titleBarStyle" = "custom";
          "[python]" = {
            "editor.tabSize" = 4;
            "editor.rulers" = [ 79 ];
          };
          "[nix]" = {
            "editor.tabSize" = 2;
            "editor.rulers" = [ 79 ];
          };
          "[shellscript]" = {
            "editor.tabSize" = 2;
            "editor.rulers" = [ 79 ];
          };
        };
      };
    };
    stylix.targets.vscode.profileNames = [ "default" ];

    home.packages = with pkgs; [
      nixfmt
    ];
  };
}