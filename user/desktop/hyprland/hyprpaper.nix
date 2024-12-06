{ ... }:
let
  #wallpaperPath = ../../../wallpapers/PXL_20231125_173902958.jpg;
  wallpaperPath = ../../../wallpapers/black.jpg;
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