{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.zed;
in {
  options.features.desktop.zed.enable = mkEnableOption "enable zed editor";

  config = mkIf cfg.enable {
    programs.zed-editor.enable = true;
  };
}