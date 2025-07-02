{ config, ... }:

{
  # Don't change the whole Waybar CSS.
  stylix.targets.waybar.addCss = false;

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        position = "top";
        layer = "top";
        height = 45;
        modules-left = [
          "group/group-power"
          "idle_inhibitor"
          "custom/brightness"
          "hyprland/workspaces"
        ];
        modules-center = [ ];
        modules-right = [
          "cpu"
          "temperature#cpu"
          "custom/gpu"
          "temperature#gpu"
          #"network"
          "bluetooth"
          "wireplumber"
          "clock"
          "tray"
        ];

        bluetooth = {
          format = " On";
          format-disabled = "󰂲 Off";
          format-connected = "󰂱 {device_alias}";
          format-connected-battery = "󰂱 {device_alias} 󰥉 {device_battery_percentage}%";
          on-click = "rfkill toggle bluetooth";
          on-click-right = "blueman-manager";
          tooltip = false;
        };

        clock = {
          interval = 60;
          format = "  {:%A, %B %d   %H:%M}";
          #format = " {:%H:%M}";
          on-click = "swaync-client -t -sw";
          tooltip = false;
        };

        cpu = {
          format = "  {avg_frequency} GHz";
          interval = 2;
          tooltip = false;
        };

        "custom/brightness" = {
          format = "{icon} {percentage}%";
          format-icons = [ "󱩐" "󱩒" "󰛨" ];
          return-type = "json";
          exec = "ddcutil getvcp 10 | grep -oP \"current.*?=\\s*\\K[0-9]+\" | { read x; echo '{\"percentage\":'\${x}'}'; }";
          on-click = "ddcutil setvcp 10 1";
          on-click-middle = "ddcutil setvcp 10 30";
          on-click-right = "ddcutil setvcp 10 70";
          interval = 2;
          tooltip = false;
        };

        "custom/gpu" = {
          exec = "amdgpu_top -d --json | jq --unbuffered --compact-output '.[0]'.gpu_metrics.current_gfxclk";
          format = "  {} MHz";
          interval = 2;
          return-type = "";
          tooltip = false;
        };

        "custom/lock" = {
          format = "";
          tooltip = false;
          on-click = "loginctl lock-session";
        };

        "custom/sleep" = {
          format = "󰋣";
          tooltip = false;
          on-click = "systemctl sleep";
        };

        "custom/power" = {
          format = " ";
          tooltip = false;
          on-click = "systemctl poweroff";
        };

        "custom/quit" = {
            format = "󰈆";
            tooltip = false;
            # Before UWSM it was "hyprctl dispatch exit";.
            on-click = "loginctl terminate-user \"\"";
        };

        "custom/reboot" = {
          format = "";
          tooltip = false;
          on-click = "reboot";
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
            "7" = "󰇏 󰇊";
            "8" = "󰇏 󰇋";
            "9" = "󰇏 󰇌";
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

        network = {
          interval = 2;
          format-ethernet = "{icon} Wired";
          format-wifi = "{icon} {essid}";
          format-disconnected = "";
          format-icons = {
            ethernet = " ";
            wifi = " ";
          };
          tooltip = true;
          tooltip-format-ethernet = " {bandwidthUpBits}\n {bandwidthDownBits}";
          tooltip-format-wifi = "󰒢 {signalStrength}%\n {bandwidthUpBits}\n {bandwidthDownBits}";
          on-click-right = "nm-connection-editor";
        };

        "temperature#cpu" = {
          hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
          input-filename = "temp1_input";
          critical-threshold = 80;
          interval = 2;
          format = "{icon} {temperatureC}°C";
          format-icons = ["" "" "" "" ""];
          tooltip = false;
        };

        "temperature#gpu" = {
          hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:03.1/0000:0a:00.0/0000:0b:00.0/0000:0c:00.0/hwmon";
          input-filename = "temp2_input";
          critical-threshold = 80;
          interval = 2;
          format = "{icon} {temperatureC}°C";
          format-icons = ["" "" "" "" ""];
          tooltip = false;
        };

        tray = {
          reverse-direction = true;
          spacing = 10;
        };

        wireplumber = {
          format = "{icon} {volume}%";
          format-muted = " ";
          format-icons = ["" "" " "];
          max-volume = 100.0;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "pavucontrol";
          scroll-step = 2.0;
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
              "custom/sleep"
              "custom/lock"
              #"custom/quit"
              "custom/reboot"
          ];
        };
      };
    };

    style = ''
      * {
        animation-timing-function: steps(6);
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
      }

      tooltip {
        background: @base01;
        border: 1px solid @base05;
      }

      #bluetooth,
      #clock,
      #custom-brightness,
      #custom-lock,
      #custom-sleep,
      #custom-hyprsunset,
      #custom-notifications,
      #custom-power,
      #custom-quit,
      #custom-reboot,
      #idle_inhibitor,
      #network,
      #temperature,
      #tray,
      #wireplumber
      {
        background-color: @base01;
        border-radius: 5px;
        color: @base04;
        font-weight: bold;
        margin: 5px;
        padding-left: 10px;
        padding-right: 10px;
        margin-top: 5px;
        margin-bottom: 5px;
      }

      #bluetooth {
        color: @base0F;
      }

      #cpu,
      #custom-gpu
      {
        background-color: @base01;
        border-radius: 5px 0px 0px 5px;
        color: @base04;
        font-weight: bold;
        padding-left: 10px;
        padding-right: 10px;
        margin-top: 5px;
        margin-bottom: 5px;
        margin-right: 0px;
        margin-left: 5px;
      }

      #custom-lock {
        color: @base05;
        padding-right: 12px;
      }

      #custom-hyprsunset {
        padding-right: 16px;
      }

      #custom-hyprsunset.enabled {
        color: @base0F;
      }

      #custom-hyprsunset.disabled {
        color: @base0A;
      }

      #custom-sleep,
      #custom-reboot
      {
        color: @base05;
      }

      #custom-power {
        color: @base08;
        padding-left: 16px;
      }

      #custom-quit {
        color: @base05;
        padding-right: 12px;
      }

      #temperature {
        border-radius: 0px 5px 5px 0px;
        margin-left: 0px;
        padding-left: 0px;
        color: @base0C;
      }

      #temperature.cpu.critical {
        color: @base08;
      }

      #temperature.gpu.critical {
        color: @base08;
      }

      #tray > .active {
        color: @base04;
      }

      #tray > .passive {
        color: @base04;
      }

      #wireplumber {
        color: @base0E;
      }

      #workspaces {
        background: @base01;
        border-radius: 5px;
        font-weight: normal;
        margin-top: 5px;
        margin-bottom: 5px;
        padding-left: 0px;
        padding-right: 0px;
      }

      #workspaces button {
        border-radius: 5px;
        color: @base04;
        padding-left: 12px;
        padding-right: 12px;
      }

      #workspaces button.active {
        background-color: @base04;
        color: @base01;
      }

      #workspaces button.urgent {
        color: @base08;
      }

      #workspaces button.empty {
        color: @base03;
      }

      #workspaces button:hover {
        box-shadow: none;
        text-shadow: none;
        transition: none;
        background-color: @base0F;
      }
  '';
  };
}