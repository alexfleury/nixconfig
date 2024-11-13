{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "Fira Sans Nerd Font 12";
    location = "top";
    theme = "~/nixosconfig/user/desktop/rofi/nord.rasi";
    extraConfig = {
      display-ssh = " ";
      display-run = " ";
      display-drun = " ";
      display-window = " ";
      display-combi = " ";
      show-icons = true;
    };
  }; # End of programs.rofi
}