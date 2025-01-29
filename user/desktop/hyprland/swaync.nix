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
    style = ''
      *{
        color: #${config.palette.foreground0};
        font-family: ${config.font};
      }

      .blank-window {
        background: transparent;
      }

      .body {
        font-size: 12px;
        font-weight: normal;
        background: transparent;
        color: white;
        text-shadow: none;
      }

      .body-image {
        margin-top: 6px;
        background-color: #${config.palette.white};
        border-radius: 12px;
      }

      .close-button {
        background: alpha(#${config.palette.foreground0}, 0.1);
        color: #${config.palette.white};
        text-shadow: none;
        padding: 0;
        border-radius: 100%;
        margin-top: 10px;
        margin-right: 16px;
        box-shadow: none;
        border: none;
        min-width: 24px;
        min-height: 24px;
      }

      .close-button:hover {
        box-shadow: none;
        background: alpha(#${config.palette.foreground0}, 0.2);
        transition: all 0.15s ease-in-out;
        border: none;
      }

      .control-center {
        background-color: alpha(#${config.palette.background3}, 0.8);
      }

      .control-center-list {
        background: transparent;
      }

      .critical {
        background: #${config.palette.red};
        padding: 2px;
        border-radius: 12px;
      }

      .floating-notifications {
        background: transparent;
      }

      .image {}

      .notification-row {
        outline: none;
      }

      .notification-row:focus,
      .notification-row:hover {
        background: #${config.palette.accent0};
      }

      .notification {
        border-radius: 12px;
        margin: 6px 12px;
        box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.3), 0 1px 3px 1px rgba(0, 0, 0, 0.7),
          0 2px 6px 2px rgba(0, 0, 0, 0.3);
        padding: 0;
      }

      .notification-content {
        background: transparent;
        padding: 6px;
        border-radius: 12px;
      }

      .notification-default-action,
      .notification-action {
        padding: 4px;
        margin: 0;
        box-shadow: none;
        background: #${config.palette.background0};
        border: 1px solid alpha(#${config.palette.foreground0}, 0.15);
        color: white;
      }

      .notification-default-action:hover,
      .notification-action:hover {
        -gtk-icon-effect: none;
        background: #${config.palette.accent3};
      }

      .notification-default-action {
        border-radius: 12px;
      }

      .notification-default-action:not(:only-child) {
        border-bottom-left-radius: 0px;
        border-bottom-right-radius: 0px;
      }

      .notification-action {
        border-radius: 0px;
        border-top: none;
        border-right: none;
      }

      .notification-action:first-child {
        border-bottom-left-radius: 10px;
      }

      .notification-action:last-child {
        border-bottom-right-radius: 10px;
        border-right: 1px solid alpha(#${config.palette.foreground0}, 0.15);
      }

      .summary {
        font-size: 12px;
        font-weight: bold;
        background: transparent;
        color: white;
        text-shadow: none;
      }

      .time {
        font-size: 10px;
        font-weight: bold;
        background: transparent;
        color: white;
        text-shadow: none;
        margin-right: 18px;
      }

      .top-action-title {
        color: white;
        text-shadow: none;
      }

      .widget-title {
        margin: 8px;
        font-size: 1.25rem;
      }

      .widget-title>button {
        font-size: initial;
        color: white;
        text-shadow: none;
        background: #${config.palette.background0};
        border: 1px solid alpha(#${config.palette.foreground0}, 0.15);
        box-shadow: none;
        border-radius: 12px;
      }

      .widget-title>button:hover {
        background: #${config.palette.accent3};
      }

      .widget-dnd {
        margin: 8px;
        font-size: 1.1rem;
        padding: 4px;
      }

      .widget-dnd>switch {
        font-size: initial;
        border-radius: 12px;
        background: #${config.palette.background0};
        border: 1px solid alpha(#${config.palette.foreground0}, 0.15);
        box-shadow: none;
      }

      .widget-dnd>switch:checked {
        background: #${config.palette.accent3};
      }

      .widget-dnd>switch slider {
        background: #${config.palette.accent3};
        border-radius: 12px;
      }

      .widget-mpris {}

      .widget-mpris-player {
        padding: 8px;
        margin: 8px;
      }

      .widget-mpris-title {
        font-weight: bold;
        font-size: 1.1rem;
      }

      .widget-mpris-subtitle {
        font-size: 1.0rem;
      }
    '';
  };
}