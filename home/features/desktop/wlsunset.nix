{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.wayland.wlsunset;
in {
  options.features.desktop.wayland.wlsunset.enable = mkEnableOption "enable wlsunset";

  config = mkIf cfg.enable {
    services.wlsunset = {
      enable= true;

      latitude = 45.4;
      longitude = -71.9;

      temperature.day = 6500;
      temperature.night = 2800;

      gamma = 1.0;
    };
  };
}