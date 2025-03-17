{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    libnotify
  ];

  services.swaync = {
    enable =  true;
    settings = {
      control-center-height = 600;
      control-center-width = 300;
      control-center-margin-top = 4;
      control-center-margin-bottom = 4;
      control-center-margin-right = 4;
      control-center-margin-left = 0;
      fit-to-screen = false;
      hide-on-clear = true;
      hide-on-action = true;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      notification-window-width = 400;
      positionX = "right";
      positionY = "top";
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      transition-time = 200;
      widgets = [
        "mpris"
        "title"
        "dnd"
        "notifications"
      ];
      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd.text = "Do Not Disturb";
        mpris = {
          image-size = 96;
          image-radius = 12;
        };
      };
    };
  };
}