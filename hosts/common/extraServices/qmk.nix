{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.extraServices.qmk;
in {
  options.extraServices.qmk.enable = mkEnableOption "enable QMK extra services";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dos2unix
      qmk
    ];
    hardware.keyboard.qmk.enable = true;
  };
}