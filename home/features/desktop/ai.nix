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
      package = pkgs.ollama-rocm;
      environmentVariables = {
        OLLAMA_CONTEXT_LENGTH = "32768";
      };
    };

    programs.claude-code.enable = true;

    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
      #anthropic.claude-code
    ];
  };
}