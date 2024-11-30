{ config, ... }:
let
  c = config.palette;
in
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "top";
        layer = "top";
        height = 42;
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
          format-alt = "  {:%H:%M}";
          tooltip-format = "{calendar}";
          tooltip = true;
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#${c.accent0}'><b>{}</b></span>";
              days = "<span color='#${c.white}'><b>{}</b></span>";
              weeks = "<span color='#${c.accent1}'><b>W{}</b></span>";
              weekdays = "<span color='#${c.accent1}'><b>{}</b></span>";
              today = "<span color='#${c.accent3}'><b><u>{}</u></b></span>";
            };
          };
        };

        cpu = {
          format = "  {usage}%";
          interval = 2;
          tooltip = false;
        };

        "custom/brightness" = {
          format = "{icon} {percentage}%";
          format-icons = [ "󱩐" "󱩒" "󰛨" ];
          return-type = "json";
          exec = "ddcutil getvcp 10 | grep -oP \"current.*?=\\s*\\K[0-9]+\" | { read x; echo '{\"percentage\":'\${x}'}'; }";
          #on-scroll-up = "ddcutil --noverify --sleep-multiplier .03 setvcp 10 + 10";
          #on-scroll-down = "ddcutil --noverify --sleep-multiplier .03 setvcp 10 - 10";
          on-click = "ddcutil setvcp 10 1";
          on-click-middle = "ddcutil setvcp 10 30";
          on-click-right = "ddcutil setvcp 10 70";
          interval = 2;
          tooltip = false;
        };

        "custom/gpu" = {
          exec = "amdgpu_top -d --json | jq --unbuffered --compact-output '.[0]'.gpu_activity.GFX.value";
          format = "  {}%";
          interval = 2;
          return-type = "";
          tooltip = false;
        };

        "custom/hyprsunset" = {
          format = "{}";
          return-type = "json";
          exec = "hyprsunset.sh";
          on-click = "killall hyprsunset; hyprsunset -t 3000";
          on-click-middle = "killall hyprsunset; hyprsunset -t 5000";
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
          format-ethernet = "{icon} Wired 󰓅 {bandwidthTotalBits}";
          format-wifi = "{icon} {essid} 󰓅 {bandwidthTotalBits}";
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
          icon-size = 12;
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
        font-family: ${config.font};
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
      }

      tooltip {
        background: #${c.background1};
        border: 1px solid #${c.foreground1};
      }

      #bluetooth,
      #clock,
      #cpu,
      #custom-brightness,
      #custom-lock,
      #custom-gpu,
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
        background-color: #${c.background1};
        border-radius: 5px;
        color: #${c.foreground0};
        font-weight: bold;
        margin: 5px;
        padding-left: 10px;
        padding-right: 10px;
        margin-top: 5px;
        margin-bottom: 5px;
      }

      #custom-lock {
        padding-right: 12px;
      }

      #custom-hyprsunset {
        color: #${c.red};
        padding-right: 16px;
      }

      #custom-hyprsunset.enabled {
        color: #${c.blue};
      }

      #custom-hyprsunset.disabled {
        color: #${c.yellow};
      }

      #custom-power {
        color: #${c.red};
        padding-left: 16px;
      }

      #custom-quit {
        padding-right: 12px;
      }

      #temperature.cpu.critical {
        background-color: #${c.foreground0};
        color: #${c.background1};
      }

      #temperature.gpu.critical {
        background-color: #${c.foreground0};
        color: #${c.background1};
      }

      #tray > .passive {
        color: #${c.blue};
      }

      #tray > .passive {
        color: #${c.red};
      }

      #tray menu * {
          color:  #${c.foreground0};
      }

      #workspaces {
        background: #${c.background1};
        border-radius: 5px;
        font-weight: normal;
        margin-top: 5px;
        margin-bottom: 5px;
        padding-left: 0px;
        padding-right: 0px;
      }

      #workspaces button {
        border-radius: 5px;
        color: #${c.foreground0};
        padding-left: 12px;
        padding-right: 12px;
      }

      #workspaces button.active {
        background-color: #${c.foreground0};
        color: #${c.background1};
      }

      #workspaces button.urgent {
        color: #${c.red};
      }
    '';
  };
}