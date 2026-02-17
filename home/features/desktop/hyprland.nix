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

        env = [
          "XDG_CURRENT_DESKTOP, Hyprland"
        ];

        input.follow_mouse = 2;

        bind = [
          "SUPER, Q, killactive,"
          "SUPER, Z, togglefloating,"
          "SUPER, P, pseudo,"
          "SUPER, C, togglesplit,"
          "SUPER, left, movefocus, l"
          "SUPER, right, movefocus, r"
          "SUPER, up, movefocus, u"
          "SUPER, down, movefocus, d"
          "SUPER_SHIFT, left, movewindow, l"
          "SUPER_SHIFT, right, movewindow, r"
          "SUPER_SHIFT, up, movewindow, u"
          "SUPER_SHIFT, down, movewindow, d"
          "SUPER, H, movefocus, l"
          "SUPER, L, movefocus, r"
          "SUPER, K, movefocus, u"
          "SUPER, J, movefocus, d"
          "SUPER_SHIFT, H, movewindow, l"
          "SUPER_SHIFT, L, movewindow, r"
          "SUPER_SHIFT, K, movewindow, u"
          "SUPER_SHIFT, J, movewindow, d"
          "SUPER, S, togglespecialworkspace, magic"
          "SUPER_SHIFT, S, movetoworkspace, special:magic"
          "SUPER, mouse_down, workspace, e+1"
          "SUPER, mouse_up, workspace, e-1"
          "SUPER, F, fullscreen"
          "SUPER, L, exec, loginctl lock-session"
        ]
        # Switch and move to workspaces.
        ++ (
          builtins.concatLists (builtins.genList (i:
            let ws = i + 5;
            in [
              "SUPER, code:1${toString i}, workspace, ${toString ws}"
              "SUPER_SHIFT, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
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
        ];
        bindl = [
          "SUPER, ESCAPE, exec, sleep 1 && hyprctl dispatch dpms toggle"
        ];
        bindm = [
          "SUPER, mouse:272, movewindow"
          "SUPER, mouse:273, resizewindow"
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