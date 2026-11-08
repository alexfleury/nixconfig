{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.extraServices.dolphin;
in {
  options.extraServices.dolphin.enable = mkEnableOption "enable dolphin extra service";

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
        kdePackages.dolphin
        kdePackages.kio
        kdePackages.kio-fuse
        kdePackages.kio-extras
        kdePackages.qtsvg
    ];

    environment.etc."xdg/menus/applications.menu".source =
      "${pkgs.kdePackages.plasma-workspace}"
      + "/etc/xdg/menus/plasma-applications.menu";
  };
}