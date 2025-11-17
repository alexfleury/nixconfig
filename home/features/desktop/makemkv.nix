{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.makemkv;
in {
  options.features.desktop.makemkv.enable = mkEnableOption "enable makemkv";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      makemkv
    ];

    home.activation = {
      makemkSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ${pkgs.makemkv}/bin/makemkvcon reg ${config.age.secrets.makemkvKey.path}
      '';
    };
  };
}