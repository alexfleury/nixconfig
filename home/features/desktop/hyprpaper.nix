{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.wayland.hyprpaper;
in {
  options.features.desktop.wayland.hyprpaper.enable = mkEnableOption "enable hyprpaper";

  config = mkIf cfg.enable {
    services.hyprpaper.enable = true;
  };
}