{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.extraServices.gaming;
in {
  options.extraServices.gaming.enable = mkEnableOption "enable gaming system extra services";

  config = mkIf cfg.enable {
    # Enable steam and gamescope.
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
        #steamtinkerlaunch    # For modding.
      ];
    };

    programs.gamescope = {
      enable = true;
      # https://github.com/NixOS/nixpkgs/issues/351516#issuecomment-2525575711
      capSysNice = false;
    };

    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
  };
}