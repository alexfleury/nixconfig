{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.hyprpaper;
in {
  options.features.desktop.hyprpaper.enable = mkEnableOption "enable hyprpaper";

  config = mkIf cfg.enable {
    services.hyprpaper.enable = lib.mkForce cfg.enable;
    services.hyprpaper.settings = lib.mkAfter {
      splash = false;
    };
  };
}