{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.wayland;
in {
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./rofi.nix
    ./swaync.nix
    ./waybar.nix
    ./wlsunset.nix
  ];

  options.features.desktop.wayland.enable = mkEnableOption "wayland extra tools and config";

  config = mkIf cfg.enable {
    features.desktop.wayland = {
      hypridle.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = true;
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
  };
}