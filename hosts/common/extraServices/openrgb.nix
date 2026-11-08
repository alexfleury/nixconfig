{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.extraServices.openrgb;
in {
  options.extraServices.openrgb.enable = mkEnableOption "enable openrgb extra service";

  config = mkIf cfg.enable {
    services.hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };
  };
}