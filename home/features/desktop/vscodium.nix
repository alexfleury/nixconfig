{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.vscodium;
  #continueYamlContig = pkgs.lib.generators.toYAML {} continueConfig;
in {
  options.features.desktop.vscodium.enable = mkEnableOption "enable codium";

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          arrterian.nix-env-selector
          continue.continue
          jnoortheen.nix-ide
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
    home.packages = [ pkgs.nixfmt-rfc-style ];

    home.file.continueConfigFile = {
      target = ".continue/config.yaml";
      text = ''
        name: Gemini 2.0 Flash
        version: 1.0.2
        schema: v1

        models:
          - name: Gemini 2.0 Flash
            provider: gemini
            model: gemini-2.0-flash
            apiKey: ''${{ secrets.GEMINI_API_KEY }}
            roles:
              - chat
              - edit
              - apply
            defaultCompletionOptions:
              contextLength: 1048576
              maxTokens: 8192
            capabilities:
              - tool_use
              - image_input
      '';
    };
  };
}