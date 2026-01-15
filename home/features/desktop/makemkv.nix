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

    systemd.user.services = {
      makemkvActivation = {
        Unit = {
          Description = "Activation of the MakeMKV software with an encrypted key.";
        };
        Install = {
          WantedBy = [ "multi-user.target" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.writeShellScript "activate-makemkv" ''
            ${pkgs.makemkv}/bin/makemkvcon reg ${config.age.secrets.makemkvKey.path} > /dev/null 2>&1
          ''}";
        };
      };
    };
  };
}