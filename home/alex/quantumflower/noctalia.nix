{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
in {
  programs.noctalia.settings.bar.default = {
    end = [
      "tray"
      "volume"
      "network"
      "bluetooth"
      "clipboard"
      "notifications"
    ];
  };
}