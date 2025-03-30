{ config, ... }:

{
  # Don't change the whole Waybar CSS.
  stylix.targets.waybar.addCss = false;

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "top";
        layer = "top";
        height = 45;
        modules-left = ["group/group-power" "idle_inhibitor" "hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = [
          "cpu"
          "temperature#cpu"
          "custom/gpu"
          "temperature#gpu"
          "network"
          "bluetooth"
          "wireplumber"
          #"custom/brightness"
          "custom/hyprsunset"
          #"tray"
          "custom/notifications"
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
          tooltip = false;
        };

        cpu = {
          format = "  {avg_frequency} GHz";
          interval = 2;
          tooltip = false;
        };

        #"custom/brightness" = {
        #  format = "{icon} {percentage}%";
        #  format-icons = [ "󱩐" "󱩒" "󰛨" ];
        #  return-type = "json";
        #  exec = "ddcutil getvcp 10 | grep -oP \"current.*?=\\s*\\K[0-9]+\" | { read x; echo '{\"percentage\":'\${x}'}'; }";
        #  on-click = "ddcutil setvcp 10 1";
        #  on-click-middle = "ddcutil setvcp 10 30";
        #  on-click-right = "ddcutil setvcp 10 70";
        #  interval = 2;
        #  tooltip = false;
        #};

        "custom/gpu" = {
          exec = "amdgpu_top -d --json | jq --unbuffered --compact-output '.[0]'.gpu_metrics.current_gfxclk";
          format = "  {} MHz";
          interval = 2;
          return-type = "";
          tooltip = false;
        };

        "custom/hyprsunset" = {
          format = "{}";
          return-type = "json";
          exec = "hyprsunset_widget";
          on-click = "killall hyprsunset; hyprsunset -t 4000 -g 80%";
          on-click-right = "killall hyprsunset";
          interval = 5;
          tooltip = false;
        };

        "custom/lock" = {
          format = "";
          tooltip = false;
          on-click = "loginctl lock-session";
        };

        "custom/notifications" = {
          format = " ";
          on-click = "swaync-client -t -sw";
          tooltip = false;
        };

        "custom/hibernate" = {
          format = "󰋣";
          tooltip = false;
          on-click = "systemctl hibernate";
        };

        "custom/power" = {
          format = " ";
          tooltip = false;
          on-click = "shutdown now";
        };

        "custom/quit" = {
            format = "󰈆";
            tooltip = false;
            on-click = "hyprctl dispatch exit";
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

        #tray = {
        #  icon-size = 12;
        #  spacing = 10;
        #};

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
              "custom/hibernate"
              "custom/lock"
              "custom/quit"
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
      #custom-hibernate,
      #custom-hyprsunset,
      #custom-notifications,
      #custom-power,
      #custom-quit,
      #custom-reboot,
      #custom-wlogout,
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

      #custom-power {
        color: @base08;
        padding-left: 16px;
      }

      #custom-quit {
        padding-right: 12px;
      }

      #temperature {
        border-radius: 0px 5px 5px 0px;
        margin-left: 0px;
        padding-left: 0px;
      }

      #temperature.gpu.critical {
        background-color: @base04;
        color: @base01;
      }

      #tray > .passive {
        color: @base0F;
      }

      #tray menu * {
          color:  @base04;
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