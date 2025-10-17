{ config, pkgs, ... }:

let
  workspaces = {
    browser = "1";
    chat = "2";
    code = "3";
    steam = "4";
  };
in
{
  home.packages = with pkgs; [
    ddcutil
    hyprcursor
    playerctl
    (import ./zoom75_info.nix { inherit pkgs; } )
  ];

  services.hyprpolkitagent.enable = true;
  xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  wayland.windowManager.hyprland = {
    enable = true;

    # Avoid conflicts with uwsm.
    systemd.enable = false;

    settings = {
      # Monitor settings.
      monitor = "DP-1, 3840x2160@239.99Hz, 0x0, 1.5, bitdepth, 10, vrr, 2";
      xwayland.force_zero_scaling = true;

      env = [
        "GDK_SCALE, 2"
      ];

      # Startup applications.
      exec-once = [
        "uwsm-app -s b -- protonvpn-app.desktop"
      ];

      input.kb_layout = "ca";

      "$mod" = "SUPER";
      # Common operations.
      bind = [
        "$mod, T, exec, uwsm-app -- kitty.desktop"
        "$mod, Q, killactive,"
        "$mod, M, exec, uwsm stop"
        "$mod, E, exec, uwsm-app -- thunar.desktop"
        "$mod, Z, togglefloating,"
        "$mod, R, exec, rofi -show drun -run-command \"uwsm-app -- {cmd}\""
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
        "$mod, ESCAPE, exec, sleep 1 && hyprctl dispatch dpms toggle"
        "CTRL_ALT, P, exec, uwsm-app -- ${pkgs.hyprshot-gui}/bin/hyprshot-gui"
        "$mod, X, exec, uwsm-app -- ${pkgs.hdrop}/bin/hdrop -f -p t -w 50 -g 50 kitty.desktop --class $terminal_1"
        "CTRL_ALT, I, exec, uwsm-app -- zoom75-info"
        "ALT, TAB, exec, rofi -modes window -show window -matching fuzzy"
        "$mod, B, exec, uwsm-app -- firefox.desktop"
        "$mod, code:49, workspace, ${workspaces.browser}"
        "$mod_SHIFT, code:49, movetoworkspacesilent, ${workspaces.browser}"
        "$mod, code:16, workspace, ${workspaces.chat}"
        "$mod_SHIFT, code:16, movetoworkspacesilent, ${workspaces.chat}"
        "$mod, code:17, workspace, ${workspaces.code}"
        "$mod_SHIFT, code:17, movetoworkspacesilent, ${workspaces.code}"
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
        #", XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        #", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
      ];
      bindl = [
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
        shadow.enabled = false;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        rounding = 10;
        blur = {
          enabled = false;
          passes = 1;
          size = 3;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = false;
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
        "4, persistent:false, monitor:DP-1, default:true"
        "5, persistent:false"
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
        "float, center, size 30% 30%, class:^(org.pulseaudio.pavucontrol)$ title:^(Volume Control)$"
        "float, center, size 30% 30%, class:^(.blueman-manager-wrapped)$ title:^(Bluetooth Devices)$"
        "float, center, size 30% 30%, class:^(nm-connection-editor)$ title:^(Network Connections)$"
        "float, title:^(.*Hyprshot.*)$"
        "workspace ${workspaces.browser}, class:^(firefox)$"
        "workspace ${workspaces.chat}, class:^(discord)$"
        "workspace ${workspaces.code}, class:^(codium)$"
        "workspace ${workspaces.steam}, class:^(steam)$"
      ];

      misc = {
        disable_hyprland_logo = true;
        disable_hyprland_qtutils_check = true;
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

    }; # End of settings.

    # Not needed anymore with UWSM?!
    # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
    #systemd.variables = ["--all"];
  };
}
