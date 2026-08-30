{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.ai;
in {
  options.features.desktop.ai.enable = mkEnableOption "enable local LLMs";

  config = mkIf cfg.enable {

    services.ollama = {
      enable = true;
      package = pkgs.ollama-vulkan;
    };

    # Plugins to install:
    # https://github.com/JuliusBrussee/caveman
    programs.claude-code.enable = true;

    programs.vscodium.profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        anthropic.claude-code
      ];

      userSettings = {
        "claudeCode.preferredLocation" =  "panel";
        "claudeCode.disableLoginPrompt" = true;
        "claudeCode.environmentVariables" = [
          {
            name = "ANTHROPIC_API_KEY";
            value = "not-needed";
          }
          {
            name = "ANTHROPIC_BASE_URL";
            value = "http://localhost:11434";
          }
          {
            name = "ANTHROPIC_AUTH_TOKEN";
            value = "ollama";
          }
          {
            name = "ANTHROPIC_MODEL";
            value = "gemma4:e4b";
          }
          {
            name = "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC";
            value = "1";
          }
          {
            name = "CLAUDE_CODE_ENABLE_TELEMETRY";
            value = "0";
          }
        ];
      };
    };
  };
}