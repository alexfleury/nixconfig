{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.wayle = {
    settings = {
      bar = {
        layout = [
          {
            center = [ "clock" ];
            left = [
              "power"
              "hyprland-workspaces"
              "media"
            ];
            right = [
              {
                name = "cpu";
                modules = [
                  "cpu"
                  "custom-cputemp"
                ];
              }
              {
                name = "gpu";
                modules = [
                  "custom-gpufreq"
                  "custom-gputemp"
                ];
              }
              "volume"
              "network"
              "bluetooth"
              "idle-inhibit"
              "systray"
              "notifications"
            ];
          }
        ];
        monitor = "*";
        show = true;
      };
      modules = {
        custom = [
          {
            border-color = "auto";
            border-show = false;
            button-bg-color = "bg-surface-elevated";
            command = "${lib.getExe pkgs.amdgpu_top} -d --json | ${lib.getExe pkgs.jq} --unbuffered --compact-output '.[0]'.gpu_metrics.current_gfxclk";
            format = "{{ output }} MHz";
            hide-if-empty = false;
            icon-bg-color = "bg-base";
            icon-color = "fg-muted";
            icon-name = "tb-image-generation";
            icon-show = true;
            id = "gpufreq";
            interval-ms = 2000;
            label-color = "fg-muted";
            label-max-length = 0;
            label-show = true;
            mode = "poll";
            restart-interval-ms = 1000;
            restart-policy = "never";
          }
          {
            border-color = "auto";
            border-show = false;
            button-bg-color = "bg-surface-elevated";
            command = "${lib.getExe pkgs.lm_sensors} amdgpu-pci-0c00 | awk '/^edge:/ {print $2}' | sed 's/^+//'";
            format = "{{ output }}";
            hide-if-empty = false;
            icon-bg-color = "bg-base";
            icon-color = "fg-muted";
            icon-name = "ld-thermometer-symbolic";
            icon-show = true;
            id = "gputemp";
            interval-ms = 2000;
            label-color = "fg-muted";
            label-max-length = 0;
            label-show = true;
            mode = "poll";
            restart-interval-ms = 1000;
            restart-policy = "never";
          }
          {
            border-color = "auto";
            border-show = false;
            button-bg-color = "bg-surface-elevated";
            command = "${lib.getExe pkgs.lm_sensors} k10temp-pci-00c3 | awk '/^Tctl:/ {print $2}' | sed 's/^+//'";
            format = "{{ output }}";
            hide-if-empty = false;
            icon-bg-color = "bg-base";
            icon-color = "fg-muted";
            icon-name = "ld-thermometer-symbolic";
            icon-show = true;
            id = "cputemp";
            interval-ms = 2000;
            label-color = "fg-muted";
            label-max-length = 0;
            label-show = true;
            mode = "poll";
            restart-interval-ms = 1000;
            restart-policy = "never";
          }
        ];
        hyprland-workspaces.workspace-map = {
            "1".icon = "si-firefoxbrowser";
            "2".icon = "si-vscodium";
            "3".icon = "si-discord";
            "4".icon = "si-steam";
            "5".icon = "tb-device-gamepad";
            "6".icon = "si-spotify";
        };
      };
    };
  };
}