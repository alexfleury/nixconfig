{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.hyprland;
  specialKey = "SUPER";
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

      # Avoid conflicts with uwsm.
      systemd.enable = false;

      settings = {
        xwayland.force_zero_scaling = true;

        env = [
          "XDG_CURRENT_DESKTOP, Hyprland"
        ];

        input.follow_mouse = 2;

        workspace = [
          "11, persistent:false, monitor:DP-1, default:true"
          "12, persistent:false"
          "13, persistent:false"
          "14, persistent:false"
          "15, persistent:false"
          "16, persistent:false"
        ];

        bind = [
          "${specialKey}, Q, killactive,"
          "${specialKey}, O, togglefloating,"
          "${specialKey}, P, pseudo,"
          "${specialKey}, I, togglesplit,"
          "${specialKey}, left, movefocus, l"
          "${specialKey}, right, movefocus, r"
          "${specialKey}, up, movefocus, u"
          "${specialKey}, down, movefocus, d"
          "${specialKey}_SHIFT, left, movewindow, l"
          "${specialKey}_SHIFT, right, movewindow, r"
          "${specialKey}_SHIFT, up, movewindow, u"
          "${specialKey}_SHIFT, down, movewindow, d"
          "${specialKey}_SHIFT, H, movewindow, l"
          "${specialKey}_SHIFT, L, movewindow, r"
          "${specialKey}_SHIFT, K, movewindow, u"
          "${specialKey}_SHIFT, J, movewindow, d"
          "${specialKey}, S, togglespecialworkspace, magic"
          "${specialKey}_SHIFT, S, movetoworkspace, special:magic"
          "${specialKey}, mouse_down, workspace, e+1"
          "${specialKey}, mouse_up, workspace, e-1"
          "${specialKey}, F, fullscreen"
          "${specialKey}, L, exec, loginctl lock-session"
        ]
        # Switch and move to workspaces.
        ++ (
          builtins.concatLists (builtins.genList (i:
            let ws = i + 11;
            in [
              "${specialKey}, code:1${toString i}, workspace, ${toString ws}"
              "${specialKey}_SHIFT, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
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
          "${specialKey}, SPACE, exec, playerctl play-pause"
        ];
        bindl = [
          "${specialKey}, ESCAPE, exec, sleep 1 && hyprctl dispatch dpms toggle"
        ];
        bindm = [
          "${specialKey}, mouse:272, movewindow"
          "${specialKey}, mouse:273, resizewindow"
        ];

        general = {
          allow_tearing = false;
          border_size = 2;
          gaps_in = 5;
          gaps_out = 5;
          layout = "dwindle";
          resize_on_border = false;
        };

        decoration = {
          shadow.enabled = true;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          rounding = 10;
          blur = {
            enabled = true;
            passes = 1;
            size = 3;
            vibrancy = 0.1696;
          };
        };

        animations = {
          enabled = true;
          animation = [
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "workspaces, 1, 6, default"
          ];
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        };

        dwindle = {
          preserve_split = true;
          pseudotile = true;
          smart_split = true;
        };

        master.new_status = "master";

        cursor.no_warps = true;

        windowrule = [
          "match:class ^(*)$, idle_inhibit fullscreen"
          "match:title ^(*)$, idle_inhibit fullscreen$"
          "match:fullscreen 1, idle_inhibit fullscreen"
        ];

        render = {
        #  direct_scanout = 1;
          cm_fs_passthrough = 1;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_hyprland_guiutils_check = true;
          force_default_wallpaper = -1;
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = false;
          focus_on_activate = true;
        };

      };
    };
  };
}