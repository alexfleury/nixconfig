{ config, ... }:
let
  c = config.palette;
in
{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        ignore_empty_input = true;
      };

      background = {
        blur_passes = 3;
        color = "rgb(${c.white})";
        path = "~/nixosconfig/wallpapers/PXL_20231125_173902958.jpg";
      };

      label = [
        {
          text = "$TIME";
          color = "rgb(${c.white})";
          font_size = 80;
          font_family = "Hack Nerd Font";
          position = "0, 130";
          halign = "center";
          valign = "center";
          text_align = "center";
        }
        {
          text = "cmd[update:43200000] echo \"\$(date +\"%A, %d %B %Y\")\"";
          color = "rgb(${c.white})";
          font_size = 20;
          font_family = "Hack Nerd Font";
          position = "0, 60";
          halign = "center";
          valign = "center";
          text_align = "center";
        }
      ];

      input-field = {
        size = "220, 40";
        dots_size = 0.33;
        dots_spacing = 0.2;
        outline_thickness = 6;
        dots_center = true;
        fade_on_empty = false;
        hide_input = false;
        capslock_color = "rgb(${c.yellow})";
        check_color = "rgb(${c.accent0})";
        fail_color = "rgb(${c.red})";
        font_color = "rgb(${c.black})";
        inner_color = "rgb(${c.white})";
        outer_color = "rgb(${c.accent3})";
        placeholder_text = "󰌾 Logged in as $USER";
        fail_text = "$FAIL ($ATTEMPTS)";
        position = "0, -20";
        halign = "center";
        valign = "center";
      };
    };
  }; # End of programs.hyprlock
}
