{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.stylix;
in {
  options.features.desktop.stylix.enable = mkEnableOption "enable stylix HM module";

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      image = ../../../wallpapers/a_pixel_art_of_a_city_street.png;
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