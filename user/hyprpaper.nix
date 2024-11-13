{ ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "~/nixosconfig/wallpapers/PXL_20231125_173902958.jpg" ];
      wallpaper = [ " ,~/nixosconfig/wallpapers/PXL_20231125_173902958.jpg" ];
    };
  }; # End of services.hyprpaper
}