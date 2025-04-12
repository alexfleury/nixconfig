{ config, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./rofi.nix
    ./swaync.nix
    ./waybar.nix
  ];

}