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
  # Hyprland is activated if the Nix option is activated.
  options.features.desktop.hyprland.enable =
    (mkEnableOption "enable hyprland home-manager config") //
    { default = osConfig.programs.hyprland.enable or false; };

  config = mkIf cfg.enable {

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
              inactive_opacity = 0.9;
              rounding = 10;
            };

            animations.enabled = true;

            dwindle.smart_split = true;

            cursor = {
              no_hardware_cursors = 1;
              no_warps = true;
            };

            misc = {
              disable_hyprland_logo = true;
              focus_on_activate = true;
              key_press_enables_dpms = false;
              mouse_move_enables_dpms = true;
              on_focus_under_fullscreen = 0;
            };

            xwayland.force_zero_scaling = true;
          };

          workspace_rule = [
            { workspace = "1"; persistent = true; default = true; }
            { workspace = "2"; persistent = true; }
            { workspace = "3"; persistent = true; }
            { workspace = "4"; persistent = true; }
            { workspace = "5"; persistent = true; }
            { workspace = "6"; persistent = true; }
          ];

          bind = lib.flatten [
            (bind "${mod} + Q" dsp.window.close { })
            (bind "${mod} + SHIFT + Q" dsp.window.kill { })
            (bind "${mod} + ESCAPE" dsp.dpms { })
            (bind "${mod} + O" dsp.window.float { })
            (bind "${mod} + P" dsp.window.pseudo { })
            (bind "${mod} + H" (dsp.focus { direction = "l"; }) { })
            (bind "${mod} + J" (dsp.focus { direction = "d"; }) { })
            (bind "${mod} + K" (dsp.focus { direction = "u"; }) { })
            (bind "${mod} + L" (dsp.focus { direction = "r"; }) { })
            (bind "${mod} + SHIFT + H" (dsp.window.move { direction = "l"; }) { })
            (bind "${mod} + SHIFT + J" (dsp.window.move { direction = "d"; }) { })
            (bind "${mod} + SHIFT + K" (dsp.window.move { direction = "u"; }) { })
            (bind "${mod} + SHIFT + L" (dsp.window.move { direction = "r"; }) { })
            (bind "${mod} + mouse:272" dsp.window.drag { mouse = true; })
            (bind "${mod} + mouse:273" dsp.window.resize { mouse = true; })
            (bind "${mod} + F" dsp.window.fullscreen { })
            (bind "${mod} + L" (dsp.exec_cmd "lock-session") { })
            #(bind "${mod} + S" dsp.workspace.toggle_special { })
            #(bind "${mod} + SHIFT + S" (dsp.window.move{ workspace = "special:magic"; }) { })
            (bind "${mod} + mouse_down" (dsp.focus { workspace = "e+1"; }) { })
            (bind "${mod} + mouse_up" (dsp.focus { workspace = "e-1"; }) { })
            # LCD brightness.
            (bind "XF86MonBrightnessUp" (dsp.exec_cmd "${lib.getExe pkgs.brightnessctl} -e set +5%") { locked = true; })
            (bind "XF86MonBrightnessDown" (dsp.exec_cmd "${lib.getExe pkgs.brightnessctl} -e set 5%-") { locked = true; })
            # Apps.
            (bind "${mod} + I" (dsp.exec_cmd "uwsm app -- ${lib.getExe pkgs.hyprshot-gui}") { })
            (bind "${mod} + SHIFT + I" (dsp.exec_cmd "uwsm app -- ${lib.getExe pkgs.wayscriber} -a") { })
            (bind "${mod} + T" (dsp.exec_cmd "xdg-terminal-exec") { })
            (bind "${mod} + E" (dsp.exec_cmd "xdg-open $HOME") { })
          ]
          ++ (
            builtins.concatLists (
              builtins.genList (x:
                let k = x + 9;
                in [
                  (bind "${mod} + code:${toString k}" (dsp.focus { workspace = "${toString x}"; }) { })
                  (bind "${mod} + SHIFT + code:${toString k}" (dsp.window.move { workspace = "${toString x}"; }) { })
                ]
              )
            7)
          )
          ++ lib.optionals config.features.desktop.wayle.enable (
            let
              audioPlay = dsp.exec_cmd "wayle media play-pause";
              audioPrev = dsp.exec_cmd "wayle media previous";
              audioNext = dsp.exec_cmd "wayle media next";
              audioOutMute = dsp.exec_cmd "wayle audio output-mute";
              audioInMute = dsp.exec_cmd "wayle audio input-mute";
              audioVolDown = dsp.exec_cmd "wayle audio output-volume -4";
              audioVolUp = dsp.exec_cmd "wayle audio output-volume +4";
            in [
              (bind "XF86AudioLowerVolume" audioVolDown { repeating = true; locked = true; })
              (bind "XF86AudioRaiseVolume" audioVolUp { repeating = true; locked = true; })
              (bind "XF86AudioMute" audioOutMute { locked = true; })
              (bind "XF86AudioMicMute" audioInMute { locked = true; })
              (bind "XF86AudioPlay" audioPlay { locked = true; })
              (bind "XF86AudioPrev" audioPrev { locked = true; })
              (bind "XF86AudioNext" audioNext { locked = true; })
              (bind "${mod} + SPACE" audioPlay { locked = true; })
              (bind "${mod} + left" audioPrev { locked = true; })
              (bind "${mod} + down" audioVolDown { repeating = true; locked = true; })
              (bind "${mod} + up" audioVolUp { repeating = true; locked = true; })
              (bind "${mod} + right" audioNext { locked = true; })
              (bind "${mod} + M" audioOutMute { locked = true; })
            ]
          )
          ++ lib.optionals config.features.desktop.rofi.enable [
            (bind "${mod} + R" (dsp.exec_cmd "rofi -show drun") { })
            (bind "ALT + TAB" (dsp.exec_cmd "rofi -show window -matching fuzzy") { })
          ]
          ++ lib.optionals config.features.desktop.wlsunset.enable [
            (bind "${mod} + W"
              (dsp.exec_cmd "systemctl --user is-active --quiet wlsunset && systemctl --user stop wlsunset || systemctl --user start wlsunset")
              { }
            )
          ];

          window_rule = [
            {
              match.fullscreen = true;
              idle_inhibit = "fullscreen";
            }
            {
              match.title = "^(Volume Control)";
              float = true;
              center = true;
              size = "{monitor_w*0.3 monitor_h*0.3}";
            }
            {
              match.class = ".blueman-manager-wrapped";
              float = true;
              center = true;
              size = "{monitor_w*0.3 monitor_h*0.3}";
            }
            {
              match.title = "^(Network Connections)";
              float = true;
              center = true;
              size = "{monitor_w*0.3 monitor_h*0.3}";
            }
            {
              match.title = "^(.*Hyprshot.*)$";
              float = true;
              center = true;
            }
            {
              match.class = "^(org.gnome.FileRoller)$";
              float = true;
            }
          ];
        };
    };
  };
}
