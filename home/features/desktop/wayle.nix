{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.wayle;
in {
  options.features.desktop.wayle.enable = mkEnableOption "enable wayle service";

  config = mkIf cfg.enable {

    services.wayle = {
        enable = true;
        autoInstallDependencies = true;

        # tip: you can automatically translate your TOML config to Nix by running
        # nix-instantiate --eval --expr 'builtins.fromTOML (builtins.readFile ./config.toml)' | nixfmt
        settings = {
          bar.scale = 0.85;
          modules = {
            bluetooth = {
              label-color = "fg-muted";
              right-click = "blueman-manager";
            };
            clock = {
              format = "%d/%m/%y (%a) %R";
              label-color = "fg-default";
            };
            cpu = {
              format = "{{ avg_freq_ghz }} GHz {{temp_c}} °C";
              icon-bg-color = "bg-base";
              icon-color = "fg-muted";
              label-color = "fg-muted";
            };
            hyprland-workspaces = {
              display-mode = "icon";
              workspace-map = {
                "11".icon = "tb-dice-1";
                "12".icon = "tb-dice-2";
                "13".icon = "tb-dice-3";
                "14".icon = "tb-dice-4";
                "15".icon = "tb-dice-5";
                "16".icon = "tb-dice-6";
              };
              workspace-padding = 0.6;
            };
            idle-inhibit.label-color = "fg-muted";
            media.label-color = "fg-muted";
            network = {
              label-color = "fg-muted";
              right-click = "nm-connection-editor";
            };
            notifications = {
              border-color = "yellow";
              icon-bg-color = "yellow";
              label-color = "fg-muted";
            };
            power.left-click = "${lib.getExe pkgs.shutdownMenu}";
            systray = {
              icon-scale = 1.05;
              item-gap = 0.5;
            };
            volume = {
              border-color = "accent";
              icon-bg-color = "accent";
              label-color = "fg-muted";
              level-icons = [
                "ld-volume-symbolic"
                "ld-volume-1-symbolic"
                "ld-volume-2-symbolic"
              ];
              right-click = "${lib.getExe pkgs.pavucontrol}";
              scroll-down = "wayle audio output-volume -4";
              scroll-up = "wayle audio output-volume +4";
            };
            weather = {
              location = "Sherbrooke";
              time-format = "24h";
            };
          };
          osd = {
            margin = 10;
            position = "top-right";
          };
          styling.scale = 0.9;
          wallpaper.engine-enabled = false;
        };
      };
  };
}