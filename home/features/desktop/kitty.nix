{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.kitty;
in {
  options.features.desktop.kitty.enable = mkEnableOption "enable kitty terminal";

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      settings = {
        enable_audio_bell = "no";
        notify_on_cmd_finish = "never";
        confirm_os_window_close = 0;
      };
    };

    home.shellAliases = {
      "kssh" = "kitty +kitten ssh";
    };
  };
}