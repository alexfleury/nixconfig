{ config, pkgs, ... }:

{
  services.wlsunset = {
    enable= true;

    latitude = 45.4;
    longitude = -71.9;

    temperature.day = 6500;
    temperature.night = 4000;

    gamma = 1.0;
  };
}
