{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cli.bash;
in {
  options.features.cli.bash.enable = mkEnableOption "enable extended bash configuration";

  config = mkIf cfg.enable {
    #https://github.com/basecamp/omarchy/blob/master/default/bash/functions
    programs.bash = {
      enable = true;
      enableCompletion = true;
      historyControl = [
        "ignoreboth"
        "erasedups"
      ];
      historyIgnore = [
        "ls"
        "cd"
        "exit"
      ];
      shellOptions = [
        "histappend"
        "checkwinsize"
        "extglob"
        "globstar"
        "checkjobs"
      ];
      bashrcExtra = lib.concatLines [
        "HISTTIMEFORMAT=\"%F %T\""
      ];
    };
  };
}