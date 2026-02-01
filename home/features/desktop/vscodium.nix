{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.vscodium;
  yamlFormat = pkgs.formats.yaml {};
  continueConfig = {
    name = "My config";
    version = "0.0.1";
    schema = "v1";
    models = [
      {
        name = "Gemini 3 Flash Preview";
        provider = "gemini";
        model = "gemini-3-flash-preview";
        apiKey = "$\{{ secrets.GEMINI_API_KEY }}";
        roles = [
          "chat"
          "edit"
          "apply"
        ];
        defaultCompletionOptions = {
          contextLength = 1048576;
          maxTokens = 65536;
        };
        capabilities = [
          "tool_use"
          "image_input"
        ];
      }
      {
        name = "Ollama";
        provider = "ollama";
        model = "AUTODETECT";
        roles = [
          "chat"
          "edit"
          "apply"
        ];
      }
    ];
  };

  continueYaml = yamlFormat.generate "config.yaml" continueConfig;
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
          "continue.telemetryEnabled" = false;
          "editor.autoClosingBrackets" = "never";
          "editor.autoClosingDelete" = "never";
          "editor.autoClosingOvertype" = "never";
          "editor.autoClosingQuotes" = "never";
          "editor.autoSurround" = "never";
          "editor.guides.bracketPairsHorizontal" = false;
          "editor.matchBrackets" = "near";
          "editor.minimap.enabled" = false;
          "editor.tabSize" = 2;
          "extensions.autoUpdate" = false;
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
    home.file.".continue/config.yaml".source = continueYaml;
  };
}