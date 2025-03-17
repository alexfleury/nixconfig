{ config, ... }:
{
  programs.hyprlock = {

    enable = true;

    settings = {

      general = {
        disable_loading_bar = true;
        hide_cursor = false;
        ignore_empty_input = true;
      };

      background = {
        blur_passes = 1;
        #color = "rgba(0, 0, 0, 1.0)";
        path = "${config.wallpaperPath}";
      };

      label = [
        {
          text = "$TIME";
          #color = "rgb(${config.palette.white})";
          font_size = 80;
          #font_family = "${config.font}";
          position = "0, 130";
          halign = "center";
          valign = "center";
          text_align = "center";
        }
        {
          text = "cmd[update:43200000] echo \"\$(date +\"%A, %d %B %Y\")\"";
          #color = "rgb(${config.palette.white})";
          font_size = 20;
          #font_family = "${config.font}";
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
        #capslock_color = "rgb(${config.palette.yellow})";
        #check_color = "rgb(${config.palette.accent0})";
        #fail_color = "rgb(${config.palette.red})";
        #font_color = "rgb(${config.palette.black})";
        #inner_color = "rgb(${config.palette.white})";
        #outer_color = "rgb(${config.palette.accent3})";
        placeholder_text = "󰌾 Logged in as $USER";
        fail_text = "$FAIL ($ATTEMPTS)";
        position = "0, -20";
        halign = "center";
        valign = "center";
      };

    };

  };
}
