{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.wayland.swaync;
in {
  options.features.desktop.wayland.swaync.enable = mkEnableOption "enable swaync";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      libnotify
    ];

    services.swaync = {
      enable =  true;
      settings = {
        control-center-height = 800;
        control-center-width = 494;
        #control-center-margin-top = 5;
        control-center-margin-right = 5;
        #control-center-margin-bottom = 5;
        control-center-margin-left = 5;
        control-center-positionX = "center";
        control-center-positionY = "top";
        fit-to-screen = false;
        hide-on-clear = true;
        hide-on-action = true;
        keyboard-shortcuts = true;
        image-visibility = "when-available";
        layer = "overlay";
        notification-2fa-action = true;
        notification-icon-size = 64;
        notification-body-image-height = 100;
        notification-body-image-width = 200;
        notification-window-width = 400;
        positionX = "right";
        positionY = "top";
        relative-timestamps = false;
        timeout = 10;
        timeout-low = 5;
        timeout-critical = 0;
        transition-time = 200;
        widgets = [
          "title"
          "dnd"
          "mpris"
          "notifications"
        ];
        widget-config = {
          title = {
            text = "Notifications";
            clear-all-button = true;
            button-text = "Clear All";
          };
          dnd.text = "Do Not Disturb";
          mpris = {
            image-size = 96;
            image-radius = 12;
          };
        };
      };
      # CSS options available at
      # https://github.com/ErikReider/SwayNotificationCenter/blob/main/data/style/style.scss
      style = lib.mkAfter ''
        .control-center {
          background: alpha(@base01, 0.8);
        }

        .widget-title {
          font-weight: bold;
        }

        .widget-dnd {
          padding-right: 8px;
          padding-left: 8px;
        }
      '';
    };
  };
}