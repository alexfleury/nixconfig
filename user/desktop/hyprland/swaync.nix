{ ... }:

{
  services.swaync = {
    enable =  true;
    settings = {
      positionX = "right";
      positionY = "top";
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
      notification-window-width = 500;
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
        label = {
          max-lines = 1;
          text = "Control Center";
        };
        mpris = {
          image-size = 96;
          image-radius = 12;
        };
      };
    };
    style = ''
      @define-color noti-border-color rgba(255, 255, 255, 0.15);
      @define-color noti-bg #2E3440;
      @define-color noti-bg-alt alpha(#383E4A, 0.8);
      @define-color noti-fg #E5E9F0;
      @define-color noti-bg-hover #81A1C1;
      @define-color noti-bg-focus #A3BE8C;
      @define-color noti-close-bg rgba(255, 255, 255, 0.1);
      @define-color noti-close-bg-hover rgba(255, 255, 255, 0.15);
      @define-color noti-urgent #BF616A;

      @define-color bg-selected rgb(0, 128, 255);

      *{
        color: @noti-fg;
        font-family: "Hack Nerd Font";
      }

      .notification-row {
        outline: none;
      }

      .notification-row:focus,
      .notification-row:hover {
        background: @noti-bg-focus;
      }

      .notification {
        border-radius: 12px;
        margin: 6px 12px;
        box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.3), 0 1px 3px 1px rgba(0, 0, 0, 0.7),
          0 2px 6px 2px rgba(0, 0, 0, 0.3);
        padding: 0;
      }

      .critical {
        background: @noti-urgent;
        padding: 2px;
        border-radius: 12px;
      }

      .notification-content {
        background: transparent;
        padding: 6px;
        border-radius: 12px;
      }

      .close-button {
        background: @noti-close-bg;
        color: white;
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
        background: @noti-close-bg-hover;
        transition: all 0.15s ease-in-out;
        border: none;
      }

      .notification-default-action,
      .notification-action {
        padding: 4px;
        margin: 0;
        box-shadow: none;
        background: @noti-bg;
        border: 1px solid @noti-border-color;
        color: white;
      }

      .notification-default-action:hover,
      .notification-action:hover {
        -gtk-icon-effect: none;
        background: @noti-bg-hover;
      }

      .notification-default-action {
        border-radius: 12px;
      }

      /* When alternative actions are visible */
      .notification-default-action:not(:only-child) {
        border-bottom-left-radius: 0px;
        border-bottom-right-radius: 0px;
      }

      .notification-action {
        border-radius: 0px;
        border-top: none;
        border-right: none;
      }

      /* add bottom border radius to eliminate clipping */
      .notification-action:first-child {
        border-bottom-left-radius: 10px;
      }

      .notification-action:last-child {
        border-bottom-right-radius: 10px;
        border-right: 1px solid @noti-border-color;
      }

      .image {}

      .body-image {
        margin-top: 6px;
        background-color: white;
        border-radius: 12px;
      }

      .summary {
        font-size: 16px;
        font-weight: bold;
        background: transparent;
        color: white;
        text-shadow: none;
      }

      .time {
        font-size: 16px;
        font-weight: bold;
        background: transparent;
        color: white;
        text-shadow: none;
        margin-right: 18px;
      }

      .body {
        font-size: 15px;
        font-weight: normal;
        background: transparent;
        color: white;
        text-shadow: none;
      }

      .top-action-title {
        color: white;
        text-shadow: none;
      }

      .control-center {
        background-color: @noti-bg-alt;
      }

      .control-center-list {
        background: transparent;
      }

      .floating-notifications {
        background: transparent;
      }

      .blank-window {
        background: transparent;
      }

      .widget-title {
        margin: 8px;
        font-size: 1.5rem;
      }

      .widget-title>button {
        font-size: initial;
        color: white;
        text-shadow: none;
        background: @noti-bg;
        border: 1px solid @noti-border-color;
        box-shadow: none;
        border-radius: 12px;
      }

      .widget-title>button:hover {
        background: @noti-bg-hover;
      }

      .widget-dnd {
        margin: 8px;
        font-size: 1.1rem;
      }

      .widget-dnd>switch {
        font-size: initial;
        border-radius: 12px;
        background: @noti-bg;
        border: 1px solid @noti-border-color;
        box-shadow: none;
      }

      .widget-dnd>switch:checked {
        background: @bg-selected;
      }

      .widget-dnd>switch slider {
        background: @noti-bg-hover;
        border-radius: 12px;
      }

      .widget-label {
        margin: 8px;
      }

      .widget-label>label {
        font-size: 1.1rem;
      }

      .widget-mpris {
        /* The parent to all players */
      }

      .widget-mpris-player {
        padding: 8px;
        margin: 8px;
      }

      .widget-mpris-title {
        font-weight: bold;
        font-size: 1.25rem;
      }

      .widget-mpris-subtitle {
        font-size: 1.1rem;
      }
    '';
  };
}