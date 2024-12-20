{ ... }:
let
  wallpaperPath = ../../../wallpapers/trees_norded.png;
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "${wallpaperPath}" ];
      wallpaper = [ " ,${wallpaperPath}" ];
    };
  }; # End of services.hyprpaper
}