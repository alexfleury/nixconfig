{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.wlsunset;
in {
  options.features.desktop.wlsunset.enable = mkEnableOption "enable wlsunset";

  config = mkIf cfg.enable {
    services.wlsunset = {
      enable= true;

      latitude = 45.4;
      longitude = -71.9;

      temperature.day = 6500;
      temperature.night = 3500;

      gamma = 1.0;
    };
  };
}
