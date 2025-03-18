{ ... }:

{
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
          "media.ffmpeg.vaapi.enabled" = true;
        };
      };
    };
  };

  stylix.targets.firefox.profileNames = [ "default" ];
}
