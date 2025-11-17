{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.extraServices.qmk;
in {
  options.extraServices.qmk.enable = mkEnableOption "enable QMK extra services";

  config = mkIf cfg.enable {
    hardware.keyboard.qmk.enable = true;
  };
}