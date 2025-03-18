{ config, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = "no";
      notify_on_cmd_finish = "never";
      confirm_os_window_close = 0;
    };
  };
}