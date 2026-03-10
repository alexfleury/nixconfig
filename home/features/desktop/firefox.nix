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
            # Disabling AI in Firefox.
            # https://www.reddit.com/r/NixOS/comments/1rkt5ag/reminder_to_declare_the_blocking_of_ai_stuff_in/
            "browser.ai.control.default" = "blocked";
            "browser.ai.control.linkPreviewKeyPoints" = "blocked";
            "browser.ai.control.pdfjsAltText" = "blocked";
            "browser.ai.control.sidebarChatbot" = "blocked";
            "browser.ai.control.smartTabGroups" = "blocked";
            "browser.ai.control.translations" = "blocked";
            "browser.ml.chat.enabled" = false;
            "browser.ml.chat.page" = false;
            "browser.ml.linkPreview.enabled" = false;
            "browser.tabs.groups.smart.enabled" = false;
            "browser.tabs.groups.smart.userEnabled" = false;
            "browser.translations.enable" = false;
            "extensions.ml.enabled" = false;
            "pdfjs.enableAltText" = false;
          };
        };
      };
    };

    stylix.targets.firefox.profileNames = [ "default" ];
  };
}