{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
with lib; let
  workspaces = {
    browser = "1";
    code = "2";
    chat = "3";
    steam = "4";
  };
  cfg = config.features.desktop.hyprland;
in {
  options.features.desktop.hyprland.enable =
    (mkEnableOption "enable hyprland home-manager config") //
    { default = osConfig.programs.hyprland.enable or false; };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      ddcutil
      hyprcursor
      playerctl
    ];

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

        "$mod" = "SUPER";
        bind = [
          "$mod, Q, killactive,"
          "$mod, M, exec, uwsm stop"
          "$mod, Z, togglefloating,"
          "$mod, R, exec, rofi -show drun"
          "$mod, P, pseudo,"
          "$mod, J, togglesplit,"
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod_SHIFT, H, movewindow, l"
          "$mod_SHIFT, L, movewindow, r"
          "$mod_SHIFT, K, movewindow, u"
          "$mod_SHIFT, J, movewindow, d"
          "$mod, S, togglespecialworkspace, magic"
          "$mod_SHIFT, S, movetoworkspace, special:magic"
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"
          "$mod, F, fullscreen"
          "$mod, L, exec, loginctl lock-session"
          "$mod, code:49, workspace, ${workspaces.browser}"
          "$mod_SHIFT, code:49, movetoworkspacesilent, ${workspaces.browser}"
          "$mod, code:16, workspace, ${workspaces.code}"
          "$mod_SHIFT, code:16, movetoworkspacesilent, ${workspaces.code}"
          "$mod, code:17, workspace, ${workspaces.chat}"
          "$mod_SHIFT, code:17, movetoworkspacesilent, ${workspaces.chat}"
          "$mod, code:18, workspace, ${workspaces.steam}"
          "$mod_SHIFT, code:18, movetoworkspacesilent, ${workspaces.steam}"
        ]
        # Switch and move to workspaces.
        ++ (
          builtins.concatLists (builtins.genList (i:
            let ws = i + 5;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod_SHIFT, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
            ]
          )
          6)
        );
        # Utility keys.
        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86AudioNext, exec, playerctl next"
        ];
        bindl = [
          "$mod, ESCAPE, exec, sleep 1 && hyprctl dispatch dpms toggle"
          "$mod, code:35, exec, ddcutil setvcp 10 + 10 --sleep-multiplier 0.13 --noverify --skip-ddc-checks --maxtries 1,1,1"
          "$mod, code:51, exec, ddcutil setvcp 10 - 10 --sleep-multiplier 0.13 --noverify --skip-ddc-checks --maxtries 1,1,1"
        ];
        # Drag mouse.
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
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
          inactive_opacity = 0.8;
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

        workspace = [
          "1, persistent:false"
          "2, persistent:false"
          "3, persistent:false"
          "4, persistent:false"
          "5, persistent:false, monitor:DP-1, default:true"
          "6, persistent:false"
          "7, persistent:false"
          "8, persistent:false"
          "9, persistent:false"
          "10, persistent:false"
        ];

        windowrule = [
          "idleinhibit fullscreen, class:^(*)$"
          "idleinhibit fullscreen, title:^(*)$"
          "idleinhibit fullscreen, fullscreen:1"
        ];

        misc = {
          disable_hyprland_logo = true;
          disable_hyprland_guiutils_check = true;
          force_default_wallpaper = -1;
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = false;
          focus_on_activate = true;
        };

        experimental = {
          xx_color_management_v4 = true;
        };

        debug = {
          full_cm_proto = true;
        };

      };
    };
  };
}