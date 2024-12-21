{ config, ... }:

{
  programs.kitty = {
    enable = true;
    font.name = "${config.font}";
    font.size = 12;
    themeFile = "Nord";
    settings = {
      background_opacity = 0.9;
      enable_audio_bell = "no";
      notify_on_cmd_finish = "never";
      confirm_os_window_close = 0;
    };
  };
}