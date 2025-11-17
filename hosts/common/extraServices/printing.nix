{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.extraServices.printing;
in {
  options.extraServices.printing.enable = mkEnableOption "enable printing extra services";

  config = mkIf cfg.enable {
    # Printing and automatic discovery of printers.
    services.printing.enable = true;
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}