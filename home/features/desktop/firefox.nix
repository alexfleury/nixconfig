{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.firefox;
in {
  options.features.desktop.firefox.enable = mkEnableOption "enable firefox";

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      policies = {
        HardwareAcceleration = true;
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };
      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
          settings = {
            "browser.tabs.groups.enabled" = false;
            "media.ffmpeg.vaapi.enabled" = true;
          };
        };
      };
    };

    stylix.targets.firefox.profileNames = [ "default" ];
  };
}