{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.wayle = {
    settings = {
      bar = {
        layout = [
          {
            center = [ "clock" "weather" ];
            left = [
              "power"
              "hyprland-workspaces"
            ];
            right = [
              "volume"
              "network"
              "bluetooth"
              "idle-inhibit"
              "battery"
              "systray"
              "notifications"
            ];
          }
        ];
        monitor = "eDP-1";
      };
    };
  };
}