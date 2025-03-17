{ config, ... }:

{
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
          #"temperature#cpu"
          "custom/gpu"
          #"temperature#gpu"
          "network"
          "bluetooth"
          "wireplumber"
          "custom/brightness"
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
          #format-alt = "  {:%H:%M}";
          #tooltip-format = "{calendar}";
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

        "custom/hyprsunset" = {
          format = "{}";
          return-type = "json";
          exec = "hyprsunset_widget";
          on-click = "killall hyprsunset; hyprsunset -t 3000";
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

        #"temperature#cpu" = {
        #  hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
        #  input-filename = "temp1_input";
        #  critical-threshold = 80;
        #  interval = 2;
        #  format = "{icon} {temperatureC}°C";
        #  format-icons = ["" "" "" "" ""];
        #  tooltip = false;
        #};

        #"temperature#gpu" = {
        #  hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:03.1/0000:0a:00.0/0000:0b:00.0/0000:0c:00.0/hwmon";
        #  input-filename = "temp2_input";
        #  critical-threshold = 80;
        #  interval = 2;
        #  format = "{icon} {temperatureC}°C";
        #  format-icons = ["" "" "" "" ""];
        #  tooltip = false;
        #};

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
  };
}