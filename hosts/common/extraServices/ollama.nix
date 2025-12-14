{
  config,
  lib,
  pkgs,
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
        package = pkgs.ollama-rocm;
        rocmOverrideGfx = "10.3.0";
      };
    };
  };
}