{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.wayland.hypridle;
in {
  options.features.desktop.wayland.hypridle.enable = mkEnableOption "enable hypridle";

  config = mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          before_sleep_cmd = "loginctl lock-session";
          lock_cmd = "pidof hyprlock || hyprlock";
        };
        listener = [
          {
            timeout = 600;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 300;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 7200;
            on-timeout = "systemctl hibernate";
          }
        ];
      };
    };
  };
}