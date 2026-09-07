{
  config,
  lib,
  osConfig,
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
      # Option discussion (if set to false).
      # https://github.com/nix-community/stylix/issues/1832#issuecomment-3169274982
      #overlays.enable = false;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
      image = ../../../wallpapers/trees.jpg;
      icons = {
        enable = true;
        dark = "Dracula";
        package = pkgs.nordzy-icon-theme;
      };
      cursor = {
        package = pkgs.nordzy-cursor-theme;
        name = "Nordzy-hyprcursors";
        size = 28;
      };
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.fira-mono;
          name = "FiraMono Nerd Font";
        };
        sansSerif = {
          package = pkgs.nerd-fonts.ubuntu-sans;
          name = "UbuntuSans Nerd Font";
        };
        serif = {
          package = pkgs.nerd-fonts.fira-code;
          name = "FiraCode Nerd Font";
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
        desktop = 0.0;
        popups = 0.8;
        terminal = 0.9;
      };
      polarity = "dark";
    };
  };
}