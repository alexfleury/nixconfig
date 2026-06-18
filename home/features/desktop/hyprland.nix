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
          exec_cmd = app: mkLuaInline ''hl.dsp.exec_cmd("${app}")'';
          focus = arg: mkLuaInline "hl.dsp.focus(${toLua { } arg})";
          window = {
            move = arg: mkLuaInline "hl.dsp.window.move(${toLua { } arg})";
            drag = mkLuaInline "hl.dsp.window.drag()";
            resize = mkLuaInline "hl.dsp.window.resize()";
            close = mkLuaInline "hl.dsp.window.close()";
            kill = mkLuaInline "hl.dsp.window.kill()";
          };
          workspace = {
            move = arg: mkLuaInline "hl.dsp.workspace.move(${toLua { } arg})";
          };
        };
        mod = "SUPER";
        workspaces = lib.stringToCharacters "abcdefgimnopqrstuvwxyz";
        in
        {
        #xwayland.force_zero_scaling = true;

        #env = [
        #  "XDG_CURRENT_DESKTOP, Hyprland"
        #];

        workspace = [
          "11, persistent:false"
          "12, persistent:false"
          "13, persistent:false"
          "14, persistent:false"
          "15, persistent:false"
          "16, persistent:false"
        ];

        #workspace_rule = map (workspace: {
        #  workspace = "name:${workspace}";
        #}) [11, 12, 13, 14];


        bind = lib.flatten [
          (bind "${mod} + q" (dsp.window.close) { })
          (bind "${mod} + SHIFT + q" (dsp.window.kill) { })

          (bind "${mod} + left" (dsp.focus { direction = "l"; }) { })
          (bind "${mod} + dowhn" (dsp.focus { direction = "d"; }) { })
          (bind "${mod} + up" (dsp.focus { direction = "u"; }) { })
          (bind "${mod} + right" (dsp.focus { direction = "r"; }) { })
          (bind "${mod} + SHIFT + left" (dsp.window.move { direction = "l"; }) { })
          (bind "${mod} + SHIFT + down" (dsp.window.move { direction = "d"; }) { })
          (bind "${mod} + SHIFT + up" (dsp.window.move { direction = "u"; }) { })
          (bind "${mod} + SHIFT + right" (dsp.window.move { direction = "r"; }) { })
          (bind "${mod} + SHIFT + h" (dsp.window.move { direction = "l"; }) { })
          (bind "${mod} + SHIFT + j" (dsp.window.move { direction = "d"; }) { })
          (bind "${mod} + SHIFT + k" (dsp.window.move { direction = "u"; }) { })
          (bind "${mod} + SHIFT + l" (dsp.window.move { direction = "r"; }) { })


          (bind "${mod} + mouse:272" dsp.window.drag { mouse = true; })
          (bind "${mod} + mouse:273" dsp.window.resize { mouse = true; })


          (bind "${mod} + SPACE" (dsp.exec_cmd "uwsm app -- vicinae toggle") { })

          (bind "XF86AudioLowerVolume" (dsp.exec_cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") {
            repeating = true;
            locked = true;
          })
          (bind "XF86AudioRaiseVolume" (dsp.exec_cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+") {
            repeating = true;
            locked = true;
          })
          (bind "XF86AudioPlay" (dsp.exec_cmd "playerctl play-pause") { locked = true; })
          (bind "XF86AudioPrev" (dsp.exec_cmd "playerctl previous") { locked = true; })
          (bind "XF86AudioNext" (dsp.exec_cmd "playerctl next") { locked = true; })

          (bind "${mod} + SHIFT + h" (dsp.window.move { direction = "l"; }) { })
          (bind "${mod} + SHIFT + j" (dsp.window.move { direction = "d"; }) { })
          (bind "${mod} + SHIFT + k" (dsp.window.move { direction = "u"; }) { })
          (bind "${mod} + SHIFT + l" (dsp.window.move { direction = "r"; }) { })

          (bind "${mod} + CONTROL + h" (dsp.workspace.move { monitor = "l"; }) { })
          (bind "${mod} + CONTROL + j" (dsp.workspace.move { monitor = "d"; }) { })
          (bind "${mod} + CONTROL + k" (dsp.workspace.move { monitor = "u"; }) { })
          (bind "${mod} + CONTROL + l" (dsp.workspace.move { monitor = "r"; }) { })

          (bind "${mod} + CONTROL + s"
            (dsp.exec_cmd "uwsm app -- ${lib.getExe pkgs.grimblast} --freeze copysave area")
            { }
          )

          (map (w: bind "${mod} + ${w}" (dsp.focus { workspace = "name:${w}"; }) { }) workspaces)
          (map (
            w: bind "${mod} + SHIFT + ${w}" (dsp.window.move { workspace = "name:${w}"; }) { }
          ) workspaces)
        ];

        bind = [
          #"${mod}, Q, killactive,"
          "${mod}, O, togglefloating,"
          "${mod}, P, pseudo,"
          #"${mod}, left, movefocus, l"
          #"${mod}, right, movefocus, r"
          #"${mod}, up, movefocus, u"
          #"${mod}, down, movefocus, d"
          #"${mod}_SHIFT, left, movewindow, l"
          #"${mod}_SHIFT, right, movewindow, r"
          #"${mod}_SHIFT, up, movewindow, u"
          #"${mod}_SHIFT, down, movewindow, d"
          #"${mod}_SHIFT, H, movewindow, l"
          #"${mod}_SHIFT, L, movewindow, r"
          #"${mod}_SHIFT, K, movewindow, u"
          #"${mod}_SHIFT, J, movewindow, d"
          "${mod}, S, togglespecialworkspace, magic"
          "${mod}_SHIFT, S, movetoworkspace, special:magic"
          "${mod}, mouse_down, workspace, e+1"
          "${mod}, mouse_up, workspace, e-1"
          "${mod}, F, fullscreen"
          "${mod}, L, exec, loginctl lock-session"
        ]
        # Switch and move to workspaces.
        ++ (
          builtins.concatLists (builtins.genList (i:
            let ws = i + 11;
            in [
              "${mod}, code:1${toString i}, workspace, ${toString ws}"
              "${mod}_SHIFT, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
            ]
          )
          6)
        );
        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86AudioNext, exec, playerctl next"
          "${mod}, SPACE, exec, playerctl play-pause"
        ];
        bindl = [
          "${mod}, ESCAPE, exec, sleep 1 && hyprctl dispatch dpms toggle"
        ];
        #bindm = [
        #  "${mod}, mouse:272, movewindow"
        #  "${mod}, mouse:273, resizewindow"
        #];

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

        window_rule = [
          {
            match.class = "^(*)";
            idle_inhibit = "fullscreen";
          }
         {
            match.fullscreen = true;
            idle_inhibit = "fullscreen";
          }
        ];

        misc = {
          disable_hyprland_logo = true;
          focus_on_activate = true;
          key_press_enables_dpms = false;
          mouse_move_enables_dpms = true;
        };

      };
    };
  };
}
