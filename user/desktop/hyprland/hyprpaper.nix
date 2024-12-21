{ config, ... }:

{
  services.hyprpaper = {

    enable = true;

    settings = {
      preload = [ "${config.wallpaperPath}" ];
      wallpaper = [ " ,${config.wallpaperPath}" ];
    };

  };
}