{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.hyprland;
in {
  options.features.desktop.hyprland.enable =
    (mkEnableOption "enable hyprland home-manager config") //
    { default = osConfig.programs.hyprland.enable or false; };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [ playerctl ];

    services.hyprpolkitagent.enable = true;

    # Setting environment variables see
    # https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#nixos-uwsm
    xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";

      # Avoid conflicts with uwsm.
      systemd.enable = false;

      settings =
        let
          mkLuaInline = lib.generators.mkLuaInline;
          toLua = lib.generators.toLua;
          mkArgs = args: { _args = args; };
          bind =
            keys: dispatcher: options:
            mkArgs [
              keys
              dispatcher
              options
            ];
          dsp = {
            dpms = mkLuaInline "hl.dsp.dpms()";
            exec_cmd = cmd: mkLuaInline ''hl.dsp.exec_cmd("${cmd}")'';
            focus = arg: mkLuaInline "hl.dsp.focus(${toLua { } arg})";
            window = {
              close = mkLuaInline "hl.dsp.window.close()";
              drag = mkLuaInline "hl.dsp.window.drag()";
              float = mkLuaInline "hl.dsp.window.float()";
              fullscreen = mkLuaInline "hl.dsp.window.fullscreen()";
              kill = mkLuaInline "hl.dsp.window.kill()";
              move = arg: mkLuaInline "hl.dsp.window.move(${toLua { } arg})";
              resize = mkLuaInline "hl.dsp.window.resize()";
              pseudo = mkLuaInline "hl.dsp.window.pseudo()";
            };
            workspace = {
              toggle_special = mkLuaInline ''hl.dsp.workspace.toggle_special("magic")'';
            };
          };
          mod = "SUPER";
        in
        {
          config = {
            general = {
              allow_tearing = false;
              border_size = 2;
              gaps_in = 5;
              gaps_out = 5;
              layout = "dwindle";
            };

            decoration = {
              inactive_opacity = 0.8;
              rounding = 10;
            };

            animations.enabled = true;

            dwindle.smart_split = true;

            cursor = {
              no_hardware_cursors = 2;
              no_warps = true;
            };

            misc = {
              disable_hyprland_logo = true;
              focus_on_activate = true;
              key_press_enables_dpms = false;
              mouse_move_enables_dpms = true;
            };

            xwayland.force_zero_scaling = true;
          };

          workspace_rule = [
            { workspace = "11"; persistent = false; default = true; }
            { workspace = "12"; persistent = false; }
            { workspace = "13"; persistent = false; }
            { workspace = "14"; persistent = false; }
            { workspace = "15"; persistent = false; }
            { workspace = "16"; persistent = false; }
          ];

          bind = lib.flatten [
            (bind "${mod} + Q" dsp.window.close { })
            (bind "${mod} + SHIFT + Q" dsp.window.kill { })
            (bind "${mod} + ESCAPE" dsp.dpms { })
            (bind "${mod} + O" dsp.window.float { })
            (bind "${mod} + P" dsp.window.pseudo { })
            (bind "${mod} + left" (dsp.focus { direction = "l"; }) { })
            (bind "${mod} + down" (dsp.focus { direction = "d"; }) { })
            (bind "${mod} + up" (dsp.focus { direction = "u"; }) { })
            (bind "${mod} + right" (dsp.focus { direction = "r"; }) { })
            (bind "${mod} + H" (dsp.focus { direction = "l"; }) { })
            (bind "${mod} + J" (dsp.focus { direction = "d"; }) { })
            (bind "${mod} + K" (dsp.focus { direction = "u"; }) { })
            (bind "${mod} + L" (dsp.focus { direction = "r"; }) { })
            (bind "${mod} + SHIFT + left" (dsp.window.move { direction = "l"; }) { })
            (bind "${mod} + SHIFT + down" (dsp.window.move { direction = "d"; }) { })
            (bind "${mod} + SHIFT + up" (dsp.window.move { direction = "u"; }) { })
            (bind "${mod} + SHIFT + right" (dsp.window.move { direction = "r"; }) { })
            (bind "${mod} + SHIFT + H" (dsp.window.move { direction = "l"; }) { })
            (bind "${mod} + SHIFT + J" (dsp.window.move { direction = "d"; }) { })
            (bind "${mod} + SHIFT + K" (dsp.window.move { direction = "u"; }) { })
            (bind "${mod} + SHIFT + L" (dsp.window.move { direction = "r"; }) { })
            (bind "${mod} + mouse:272" dsp.window.drag { mouse = true; })
            (bind "${mod} + mouse:273" dsp.window.resize { mouse = true; })
            (bind "${mod} + F" dsp.window.fullscreen { })
            (bind "${mod} + L" (dsp.exec_cmd "lock-session") { })
            (bind "${mod} + S" dsp.workspace.toggle_special { })
            (bind "${mod} + SHIFT + S" (dsp.window.move{ workspace = "special:magic"; }) { })
            (bind "${mod} + mouse_down" (dsp.focus { workspace = "e+1"; }) { })
            (bind "${mod} + mouse_up" (dsp.focus { workspace = "e-1"; }) { })
            # Media controls.
            (bind "XF86AudioLowerVolume" (dsp.exec_cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%- -l 1") {
              repeating = true;
              locked = true;
            })
            (bind "XF86AudioRaiseVolume" (dsp.exec_cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+") {
              repeating = true;
              locked = true;
            })
            (bind "XF86AudioMute" (dsp.exec_cmd "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") {
              locked = true;
            })
            (bind "XF86AudioMicMute" (dsp.exec_cmd "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle") {
              locked = true;
            })
            (bind "XF86AudioPlay" (dsp.exec_cmd "playerctl play-pause") { locked = true; })
            (bind "XF86AudioPrev" (dsp.exec_cmd "playerctl previous") { locked = true; })
            (bind "XF86AudioNext" (dsp.exec_cmd "playerctl next") { locked = true; })
            (bind "${mod} + SPACE" (dsp.exec_cmd "playerctl play-pause") { locked = true; })
          ]
          ++ (
            builtins.concatLists (
              builtins.genList (i:
                let ws = i + 11;
                in [
                  (bind "${mod} + code:1${toString i}" (dsp.focus { workspace = "${toString ws}"; }) { })
                  (bind "${mod} + SHIFT + code:1${toString i}" (dsp.window.move { workspace = "${toString ws}"; }) { })
                ]
              )
            6)
          );

          window_rule = [
            {
              match.fullscreen = true;
              idle_inhibit = "fullscreen";
            }
          ];
        };
      };
  };
}
