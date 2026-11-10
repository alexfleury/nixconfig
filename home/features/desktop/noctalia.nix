{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.noctalia;
  nocNamespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$";
in {
  options.features.desktop.noctalia.enable = mkEnableOption "enable noctalia service";

  config = mkIf cfg.enable {

    programs.noctalia = {
      enable = true;
      checkConfig = true;
      systemd.enable = true;

      settings = {
        bar.default = {
          scale = 1.20;
          start = [ "session" "workspaces" ];
          widget_spacing = 12;
        };

        control_center = {
          media.show_visualizer = false;
          shortcuts = [
            { type = "wifi"; }
            { type = "bluetooth"; }
            { type = "caffeine"; }
            { type = "nightlight"; }
            { type = "notification"; }
            { type = "power_profile"; }
          ];
        };
        idle = {
          behavior_order = [
            "lock"
            "screen-off"
            "lock-and-suspend"
          ];
          behavior = {
            lock = {
              action = "lock";
              enabled = false;
              timeout = 600.0;
            };
            lock-and-suspend = {
              action = "lock_and_suspend";
              enabled = false;
              timeout = 1800.0;
            };
            screen-off = {
              action = "screen_off";
              enabled = false;
              timeout = 660.0;
            };
          };
        };
        location.address = "Sherbrooke, Canada";
        lockscreen = {
          enabled = false;
          fingerprint = false;
          transition = [ ];
        };
        lockscreen_widgets.enabled = false;
        nightlight = {
          enabled = true;
          temperature_night = 3500;
        };
        widget.workspaces.style = "minimal";
        widget.tray.hidden = [ "blueman" "nm-applet" ];
      };
    };

    wayland.windowManager.hyprland.settings = {
      window_rule = [
        {
          name = "noctalia-no-anim";
          match.namespace = nocNamespace;
          no_anim = true;
        }
      ];

      layer_rule = [
        {
          name = "noctalia-blur";
          match.namespace = nocNamespace;
          ignore_alpha = 0.5;
          blur = true;
          blur_popups = true;
        }
      ];
    };

    services.hypridle.settings.general.lock_cmd = lib.mkDefault "noctalia msg session lock";
  };
}