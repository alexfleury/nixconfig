{ config, pkgs, ... }:
let
  configPath = ".config/rofi";
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    #font = "Fira Sans Nerd Font 12";
    location = "top";
    #theme = "~/${configPath}/nord.rasi";
    extraConfig = {
      display-ssh = " ";
      display-run = " ";
      display-drun = " ";
      display-window = " ";
      display-combi = " ";
      show-icons = true;
    };
  };
}