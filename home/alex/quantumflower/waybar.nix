{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.waybar = {
    settings = {
      mainBar = {
        modules-right = [
          "cpu"
          "temperature#cpu"
          "custom/gpu"
          "temperature#gpu"
          "bluetooth"
          "wireplumber"
          # Can't change brightness when hdr is turned on.
          #"custom/brightness"
          "idle_inhibitor"
          "tray"
        ];
        "custom/gpu".exec = "${lib.getExe pkgs.amdgpu_top} -d --json | ${lib.getExe pkgs.jq} --unbuffered --compact-output '.[0]'.gpu_metrics.current_gfxclk";
        "hyprland/workspaces".format-icons = {
          "1" = "󰈹";
          "2" = "";
          "3" = "󰙯";
          "4" = "󰓓";
          "5" = "󱎓";
          "6" = "";
        };
        "temperature#cpu" = {
          hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
          input-filename = "temp1_input";
        };
        "temperature#gpu" = {
          hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:03.1/0000:0a:00.0/0000:0b:00.0/0000:0c:00.0/hwmon";
          input-filename = "temp2_input";
        };
      };
    };
  };
}