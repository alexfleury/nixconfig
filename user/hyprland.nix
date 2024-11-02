{ config, pkgs, ... }:
let
  color = config.palette;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitor settings.
      monitor = ",preferred,auto,auto";

      # Common applications.
      "$terminal" = "kitty";
      "$fileManager" = "nautilus -w";
      "$menu" = "rofi -show drun";

      # Startup applications.
      exec-once = [
        "waybar"
        "hyprpaper"
        "hypridle"
        "swaync"
        #"systemctl --user start hyprpolkitagent"
      ];

      env = [
        "XCURSOR_SIZE,28"
        "XCURSOR_THEME,Nordzy-cursors"
        "HYPRCURSOR_SIZE,28"
        "HYPRCURSOR_THEME,Nordzy-cursors"
      ];

      # Setting the keyboard.
      input.kb_layout = "ca";

      # Mod keys is the super key.
      "$mod" = "SUPER";

      # Common operations.
      bind = [
        "$mod, T, exec, $terminal"
        "$mod, Q, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, $fileManager"
        "$mod, V, togglefloating,"
        "$mod, R, exec, $menu"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
        "$mod, F, fullscreen"
        "$mod, L, exec, hyprlock"
      ]
      # Switch and move to workspaces 1 to 6.
      ++ (
        builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        )
        6)
      );
      # Utility keys.
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
      # Drag mouse.
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      #bindsym = [
      #  "$mod+Shift+n exec swaync-client -t -sw"
      #];

      general = {
        allow_tearing = false;
        border_size = 2;
        "col.active_border" = "rgb(${color.blue0}) rgb(${color.blue3}) 45deg";
        "col.inactive_border" = "rgb(${color.grey})";
        gaps_in = 4;
        gaps_out = 4;
        layout = "dwindle";
        resize_on_border = false;
      };

      decoration = {
        active_opacity = 1.0;
        "col.shadow" = "rgba(1a1a1aee)";
        drop_shadow = true;
        inactive_opacity = 1.0;
        rounding = 10;
        shadow_range = 4;
        shadow_render_power = 3;
        blur = {
          enabled = true;
          passes = 1;
          size = 3;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
        animation = [
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "workspaces, 1, 6, default"
        ];
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
      };

      dwindle = {
        preserve_split = true;
        pseudotile = true;
      };

      master.new_status = "master";

      misc = {
        disable_hyprland_logo = true;
        force_default_wallpaper = -1;
      };

      gestures.workspace_swipe = false;

      windowrulev2 = "suppressevent maximize, class:.*";
    };
    #plugins = [ pkgs.hyprlandPlugins.hyprbars ];
  }; # End of wayland.windowManager.hyprland

  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };

      background = {
        blur_passes = 1;
        blur_size = 7;
        color = "rgb(${color.almostblack})";
        path = "~/nixosconfig/wallpapers/PXL_20231125_173902958.jpg";
      };

      label = [
        {
          text = "$TIME";
          color = "rgb(${color.white0})";
          font_size = 80;
          font_family = "Fira Sans Nerd Font";
          position = "0, 130";
          halign = "center";
          valign = "center";
          text_align = "center";
        }
        {
          text = "cmd[update:43200000] echo \"\$(date +\"%A, %d %B %Y\")\"";
          color = "rgb(${color.white0})";
          font_size = 20;
          font_family = "Fira Sans Nerd Font";
          position = "0, 60";
          halign = "center";
          valign = "center";
          text_align = "center";
        }
      ];

      input-field = {
        size = "250, 50";
        dots_size = 0.33;
        dots_spacing = 0.2;
        outline_thickness = 6;
        dots_center = true;
        fade_on_empty = false;
        hide_input = false;
        capslock_color = "rgb(${color.yellow})";
        check_color = "rgb(${color.blue0})";
        fail_color = "rgb(${color.red})";
        font_color = "rgb(${color.almostblack})";
        inner_color = "rgb(${color.white0})";
        outer_color = "rgb(${color.blue3})";
        placeholder_text = "󰌾 Logged in as $USER";
        fail_text = "$FAIL ($ATTEMPTS)";
        position = "0, -20";
        halign = "center";
        valign = "center";
      };
    };
  }; # End of programs.hyprlock

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        before_sleep_cmd = "hyprlock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        #{
        #  timeout = 300;
        #  on-timeout = "brightnessctl -s set 10";
        #  on-resume = "brightnessctl -r";
        #}
        {
          timeout = 600;
          on-timeout = "hyprlock";
        }
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  }; # End of services.hypridle

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "top";
        layer = "top";
        height = 30;
        modules-left = ["group/group-power" "idle_inhibitor" "hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = [
          #"tray"
          "cpu"
          "temperature#cpu"
          "custom/gpu"
          "temperature#gpu"
          #"memory"
          "network"
          "bluetooth"
          "wireplumber"
          "custom/notifications"
        ];

        bluetooth = {
          format = "";
          format-disabled = "󰂲";
          format-connected = "󰂱";
          tooltip = false;
        };

        clock = {
          interval = 60;
          format = "  {:%H:%M}";
          format-alt = "  {:%A, %B %d   %H:%M}";
          tooltip = false;
        };

        cpu = {
          format = " {usage}%";
          interval = 2;
          tooltip = false;
        };

        "custom/notifications" = {
          format = " ";
          on-click = "swaync-client -t -sw";
          tooltip = false;
        };

        "custom/gpu" = {
          exec = "cat /sys/class/hwmon/hwmon3/device/gpu_busy_percent";
          format = "  {}%";
          interval = 2;
          return-type = "";
          tooltip = false;
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "󰇊";
            "2" = "󰇋";
            "3" = "󰇌";
            "4" = "󰇍";
            "5" = "󰇎";
            "6" = "󰇏";
          };
          sort-by-number = true;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = " ";
            deactivated = " ";
          };
          tooltip = false;
        };

        #memory = {
        #  format = "  {}%";
        #  format-alt = "  {used}/{total} GiB";
        #  interval = 5;
        #};

        network = {
          interval = 1;
          interface = "enp9s0";
          format = "{icon} 󰓅 {bandwidthTotalBits}";
          format-disconnected = "";
          format-icons = {
            ethernet = " ";
            wifi = " ";
          };
          tooltip = true;
          tooltip-format-wifi = "SSID: {essid}\n󰒢 {signalStrength}%\n {bandwidthUpBits}\n {bandwidthDownBits}";
          on-click = "kitty nmtui";
        };

        "temperature#cpu" = {
          #"hwmon-path": "/sys/class/hwmon/hwmon3/temp1_input",
          #"hwmon-path": "/sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input",
          hwmon-path-abs = "/sys/devices/platform/coretemp.0/hwmon";
          input-filename = "temp1_input";
          critical-threshold = 80;
          interval = 2;
          format = "{icon} {temperatureC}°C";
          format-icons = ["" "" "" "" ""];
          tooltip = false;
        };

        "temperature#gpu" = {
          hwmon-path-abs = "/sys/class/hwmon/hwmon3/";
          input-filename = "temp2_input";
          critical-threshold = 80;
          interval = 2;
          format = "{icon} {temperatureC}°C";
          format-icons = ["" "" "" "" ""];
          tooltip = false;
        };

        #tray = {
        #  icon-size = 12;
        #  spacing = 10;
        #  show-passive-items = false;
        #};

        wireplumber = {
          format = "{icon} {volume}%";
          format-muted = " ";
          format-icons = ["" "" " "];
          max-volume = 100.0;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          tooltip = false;
        };

        "group/group-power" = {
            orientation = "inherit";
            drawer = {
              transition-duration = 500;
              children-class = "not-power";
              transition-left-to-right = true;
            };
            modules = [
                "custom/power"
                "custom/lock"
                "custom/quit"
                "custom/reboot"
            ];
        };
        "custom/quit" = {
            format = "󰈆";
            tooltip = false;
            on-click = "hyprctl dispatch exit";
        };
        "custom/lock" = {
          format = "";
          tooltip = false;
          on-click = "hyprlock";
        };
        "custom/reboot" = {
          format = "";
          tooltip = false;
          on-click = "reboot";
        };
        "custom/power" = {
          format = " ";
          tooltip = false;
          on-click = "shutdown now";
        };
      };
    };
    style = ''
      * {
        animation-timing-function: steps(6);
        border: none;
        border-radius: 0;
        font-family: Fira Mono Nerd Font;
        font-size: 12px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
      }

      tooltip {
        background: #2e3440;
        border: 1px solid #cdd6f4;
      }

      #bluetooth,
      #clock,
      #cpu,
      #custom-lock,
      #custom-gpu,
      #custom-notifications,
      #custom-power,
      #custom-quit,
      #custom-reboot,
      #custom-wlogout,
      #idle_inhibitor,
      #memory,
      #network,
      #temperature,
      #wireplumber
      {
        background-color: #2e3440;
        border-radius: 5px;
        color: #cdd6f4;
        font-weight: bold;
        margin: 5px;
        padding-left: 10px;
        padding-right: 10px;
        margin-top: 2px;
        margin-bottom: 2px;
      }

      #bluetooth {
        color: #5e81ac;
      }

      #cpu {
        color: #a3be8c;
      }

      #custom-lock {
        color: #8fbcbb;
        padding-right: 12px;
      }

      #custom-gpu {
        color: #81a1c1;
      }

      #custom-notifications {
        color: #d8dee9;
      }

      #custom-power {
        color: #BF616A;
        padding-left: 12px;
      }

      #custom-quit {
        color: #88c0d0;
        padding-right: 12px;
      }

      #custom-reboot {
        color: #81a1c1;
      }

      #custom-wlogout {
        color: #BF616A;
        padding-left: 12px;
      }

      #idle_inhibitor {
        color: #5e81ac;
      }

      #memory {
        color: #88c0d0;
      }

      #network {
        color: #B48EAD;
      }

      #temperature.cpu {
        color: #8fbcbb;
      }

      #temperature.cpu.critical {
        background-color: #88c0d0;
        color: #2e3440;
      }

      #temperature.gpu {
        color: #5e81ac;
      }

      #temperature.cpu.critical {
        background-color: #5e81ac;
        color: #2e3440;
      }

      #wireplumber {
        color: #ebcb8b;
      }

      #workspaces {
        background: #2e3440;
        border-radius: 5px;
        font-weight: normal;
        margin: 5px;
        margin-top: 2px;
        margin-bottom: 2px;
      }

      #workspaces button {
        border-radius: 5px;
        color: #d8dee9;
      }

      #workspaces button.active {
        background-color: #d8dee9;
        color: #2e3440;
      }

      #workspaces button.urgent {
        color: #bf616a;
      }

      #tray {
        background-color: #cdd6f4;
        border-radius: 5px;
        font-weight: bold;
        margin: 5px;
        padding-left: 10px;
        padding-right: 10px;
        margin-top: 2px;
        margin-bottom: 2px;
      }
    '';
  };

  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      control-center-margin-top = 4;
      control-center-margin-bottom = 4;
      control-center-margin-right = 4;
      control-center-margin-left = 0;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      fit-to-screen = true;
      control-center-width = 500;
      control-center-height = 600;
      notification-window-width = 500;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
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
        font-family: "Fira Sans Nerd Font";
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

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "~/nixosconfig/wallpapers/PXL_20231125_173902958.jpg" ];
      wallpaper = [ " ,~/nixosconfig/wallpapers/PXL_20231125_173902958.jpg" ];
    };
  }; # End of services.hyprpaper

  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "never";
  }; # End of services.udiskie

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "Fira Sans Nerd Font 12";
    location = "top";
    theme = "~/nixosconfig/user/desktop/rofi/nord.rasi";
    extraConfig = {
      display-ssh = " ";
      display-run = " ";
      display-drun = " ";
      display-window = " ";
      display-combi = " ";
      show-icons = true;
    };
  }; # End of programs.rofi

}
