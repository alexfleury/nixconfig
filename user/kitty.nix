{ ... }:

{
  programs.kitty = {
    enable = true;
    font.name = "Fira Mono Nerd Font";
    font.size = 12;
    themeFile = "Nord";
    settings = {
      background_opacity = 0.9;
      enable_audio_bell = "no";
      notify_on_cmd_finish = "unfocused";
      confirm_os_window_close = 0;
    };
  };
}