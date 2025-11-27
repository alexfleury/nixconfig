{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.extraServices.ollama;
in {
  options.extraServices.ollama.enable = mkEnableOption "enable local LLMs";

  config = mkIf cfg.enable {
    services = {
      ollama = {
        enable = true;
        acceleration = "rocm";
        rocmOverrideGfx = "10.3.0";
      };
    };
  };
}