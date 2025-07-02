{ config, pkgs, ... }:

{
  services.wlsunset = {
    enable= true;

    latitude = 45.404171;
    longitude = -71.892914;

    temperature.day = 6500;
    temperature.night = 4000;

    gamma = 1.0;
  };
}
