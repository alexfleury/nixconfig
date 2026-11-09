{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.noctalia;
  nocNamespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$";
in {
  options.features.desktop.noctalia.enable = mkEnableOption "enable noctalia service";

  config = mkIf cfg.enable {

    programs.noctalia = {
      enable = true;

      systemd.enable = true;

      #settings = {
      #};
    };

    wayland.windowManager.hyprland.settings = {
      window_rule = [
        {
          name = "noctalia-no-anim";
          match.namespace = nocNamespace;
          no_anim = true;
        }
      ];

      layer_rule = [
        {
          name = "noctalia-blur";
          match.namespace = nocNamespace;
          ignore_alpha = 0.5;
          blur = true;
          blur_popups = true;
        }
      ];
    };
  };
}