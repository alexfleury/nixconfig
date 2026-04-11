{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.extraServices.windowsapps;
in {
  options.extraServices.windowsapps.enable = mkEnableOption "enable winboat for windows apps";

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      winboat
    ];

    virtualisation.docker.enable = true;
    users.users."alex".extraGroups = [ "docker" ];
  };
}