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
      checkConfig = true;
      systemd.enable = true;

      settings = {
        bar.default = {
          scale = 1.15;
          start = [ "launcher" "workspaces" ];
        };

        control_center = {
          media.show_visualizer = false;
          shortcuts.type = [
            "wifi"
            "bluetooth"
            "caffeine"
            "power_profile"
          ];
        };
        location.address = "Sherbrooke, Canada";
        lockscreen.enable = false;
        widget.launcher.glyph = "terminal-2";
        widget.workspaces.style = "minimal";
      };
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