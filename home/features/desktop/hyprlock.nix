{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.wayland.hyprlock;
in {
  options.features.desktop.wayland.hyprlock.enable = mkEnableOption "enable hyprlock";

  config = mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = false;
          ignore_empty_input = true;
        };
        background.blur_passes = 1;
        label = [
          {
            text = "$TIME";
            font_size = 80;
            position = "0, 130";
            halign = "center";
            valign = "center";
            text_align = "center";
          }
          {
            text = "cmd[update:43200000] echo \"\$(date +\"%A, %d %B %Y\")\"";
            font_size = 20;
            position = "0, 60";
            halign = "center";
            valign = "center";
            text_align = "center";
          }
        ];
        input-field = {
          size = "300, 50";
          dots_size = 0.33;
          dots_spacing = 0.2;
          outline_thickness = 6;
          dots_center = true;
          fade_on_empty = false;
          hide_input = false;
          placeholder_text = "󰌾 Logged in as $USER";
          fail_text = "$FAIL ($ATTEMPTS)";
          position = "0, -20";
          halign = "center";
          valign = "center";
        };
      };
    };
  };
}