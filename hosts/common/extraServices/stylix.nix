{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.extraServices.stylix;
in {
  options.extraServices.stylix.enable = mkEnableOption "enable stylix extra services";

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
      # Local file.
      image = pkgs.requireFile {
        name = "a_street_with_buildings_and_signs.png";
        url = "https://github.com/dharmx/walls";
        sha256 = "277855097285c4824f7ed1ebbf1319ddf1ba9700364a338b6870fde81c44c54b";
      };
      #./wallpapers/a_street_with_buildings_and_signs.png;
      # Remote file.
      #image = "${wallpaperRepo}/first-collection/nixos.png";
      icons = {
        enable = true;
        dark = "Dracula";
        package = pkgs.dracula-icon-theme;
      };
      cursor = {
        package = pkgs.qogir-icon-theme;
        name = "Qogir Cursors";
        size = 28;
      };
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.fira-mono;
          name = "Fira Mono Nerd Font";
        };
        sansSerif = {
          package = pkgs.nerd-fonts.ubuntu-sans;
          name = "Ubuntu Sans Nerd Font";
        };
        serif = {
          package = pkgs.nerd-fonts.fira-code;
          name = "Fira Code Nerd Font";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          applications = 12;
          desktop = 12;
          popups = 10;
          terminal = 12;
        };
      };
      opacity = {
        applications = 1.0;
        desktop = 1.0;
        popups = 0.8;
        terminal = 0.8;
      };
      polarity = "dark";
    };
  };
}