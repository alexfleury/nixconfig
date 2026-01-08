{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.wayland.hyprpaper;
in {
  options.features.desktop.wayland.hyprpaper.enable = mkEnableOption "enable hyprpaper";

  config.services.hyprpaper.enable = lib.mkForce cfg.enable;
}