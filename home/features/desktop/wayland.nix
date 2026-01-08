{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.wayland;
in {
  options.features.desktop.wayland.enable = mkEnableOption "wayland extra tools and config";

  config = mkIf cfg.enable {
    features.desktop.wayland = {
      hypridle.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = false;
      rofi.enable = true;
      swaync.enable = true;
      waybar.enable = true;
      wlsunset.enable = true;
    };

    home.packages = with pkgs; [
      wayscriber
    ];

    services.cliphist = {
      enable = true;
      extraOptions = [
        "-max-dedupe-search"
        "10"
        "-max-items"
        "500"
      ];
    };

    # Temporary (waiting stylix hyprpaper fix).
    services.wpaperd.enable = true;
  };
}