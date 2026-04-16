{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.extraServices.printing;
in {
  options.extraServices.printing.enable = mkEnableOption "enable printing extra services";

  config = mkIf cfg.enable {

    services.printing = {
      enable = true;
      drivers = with pkgs; [
        brlaser
        brgenml1lpr
        brgenml1cupswrapper
      ];
    };

    # Automatic discovery of printers.
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}