{
  config,
  lib,
  pkgs,
  ...
}:
let
  customDefaults = {
    border-color = "auto";
    border-show = false;
    button-bg-color = "bg-surface-elevated";
    hide-if-empty = false;
    icon-bg-color = "bg-base";
    icon-color = "fg-muted";
    icon-show = true;
    label-color = "fg-muted";
    label-max-length = 0;
    label-show = true;
    mode = "poll";
    restart-policy = "never";
  };
  temperatureModule =
    {
      id,
      sensor,
      field,
    }:
    customDefaults
    // {
      inherit id;
      command = ''
        ${lib.getExe pkgs.lm_sensors} ${sensor} |
          awk '
            /^${field}/ {
              t=$2
              gsub(/^\+/, "", t)
              n=t
              gsub(/°C$/, "", n)
              p=int((n - 20) * 100 / 80)
              if (p < 0) p=0
              if (p > 100) p=100
              printf "{\"percentage\": %d, \"T\": \"%s\"}\n", p, t
            }
          '
      '';
      format = "{{ T }}";
      icon-name = "ld-thermometer-symbolic";
      icon-names = [
        "cm-temperature-0-symbolic"
        "cm-temperature-1-symbolic"
        "cm-temperature-2-symbolic"
        "cm-temperature-3-symbolic"
      ];
      interval-ms = 5000;
    };
in {
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
          (customDefaults // {
            id = "gpufreq";
            command = ''
              ${lib.getExe pkgs.amdgpu_top} -d --json |
                ${lib.getExe pkgs.jq} \
                  --unbuffered \
                  --compact-output \
                  '.[0].gpu_metrics.current_gfxclk'
            '';
            format = "{{ output }} MHz";
            icon-name = "tb-image-generation";
            interval-ms = 2000;
          })
          (temperatureModule {
            id = "gputemp";
            sensor = "amdgpu-pci-0c00";
            field = "edge:";
          })

          (temperatureModule {
            id = "cputemp";
            sensor = "k10temp-pci-00c3";
            field = "Tctl:";
          })
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