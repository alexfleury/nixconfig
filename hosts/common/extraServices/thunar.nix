{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.extraServices.thunar;
in {
  options.extraServices.thunar.enable = mkEnableOption "enable thunar extra services";

  config = mkIf cfg.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };
    programs.xfconf.enable = true;

    # Mount, trash, and other functionalities.
    services.gvfs.enable = true;
    # Thumbnail support for images
    services.tumbler.enable = true;

    environment.systemPackages = with pkgs; [
      file-roller
      p7zip
    ];
  };
}