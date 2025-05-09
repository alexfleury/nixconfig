{ config, pkgs, ... }:

let
  blueman_popup = "class:^(.blueman-manager-wrapped)$ title:^(Bluetooth Devices)$";
  nm_popup = "class:^(nm-connection-editor)$ title:^(Network Connections)$";
  pavucontrol_popup = "class:^(org.pulseaudio.pavucontrol)$ title:^(Volume Control)$";
in
{
  home.packages = with pkgs; [
    hdrop
    hyprcursor
    hyprpicker
    hyprshot
    hyprshot-gui
    hyprsunset
    playerctl
  ];

  services.hyprpolkitagent.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;

    # Avoid conflicts with uwsm.
    systemd.enable = false;

    settings = {
      # Monitor settings.
      monitor = "DP-1, 3840x2160@239.99Hz, 0x0, 1.5, bitdepth, 10, vrr, 2";
      xwayland.force_zero_scaling = true;

      # Common applications.
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$menu" = "rofi -show drun -run-command \"uwsm-app -- {cmd}\"";

      # Startup applications.
      exec-once = [
        "uwsm-app -s b -- protonvpn-app.desktop"
      ];

      input.kb_layout = "ca";

      # Mod keys is the super key.
      "$mod" = "SUPER";
      "$modd" = "SHIFT";

      # Common operations.
      bind = [
        "$mod, T, exec, uwsm-app -- $terminal"
        "$mod, Q, killactive,"
        "$mod, M, exec, uwsm stop"
        "$mod, E, exec, uwsm-app -- $fileManager"
        "$mod, V, togglefloating,"
        "$mod, R, exec, $menu"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod $modd, H, movewindow, l"
        "$mod $modd, L, movewindow, r"
        "$mod $modd, K, movewindow, u"
        "$mod $modd, J, movewindow, d"
        "$mod, S, togglespecialworkspace, magic"
        "$mod $modd, S, movetoworkspace, special:magic"
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
        "$mod, F, fullscreen"
        "$mod, L, exec, loginctl lock-session"
        "$mod, ESCAPE, exec, sleep 1 && hyprctl dispatch dpms toggle"
        "$mod, I, exec, uwsm-app -- ${pkgs.hyprshot-gui}/bin/hyprshot-gui"
        "$mod, X, exec, uwsm-app -- ${pkgs.hdrop}/bin/hdrop -f -p t -w 50 -g 50 $terminal --class $terminal_1"
      ]
      # Switch and move to workspaces.
      ++ (
        builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod $modd, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
          ]
        )
        9)
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

      gestures.workspace_swipe = false;

      cursor.no_warps = true;

      workspace = [
        "1, persistent:true"
        "2, persistent:true"
        "3, persistent:true"
        "4, persistent:true"
        "5, persistent:true"
        "6, persistent:true"
        "7, persistent:false"
        "8, persistent:false"
        "9, persistent:false"
      ];

      windowrule = [
        "idleinhibit fullscreen, class:^(*)$"
        "idleinhibit fullscreen, title:^(*)$"
        "idleinhibit fullscreen, fullscreen:1"
        "float, ${pavucontrol_popup}"
        "center ${pavucontrol_popup}"
        "float, ${pavucontrol_popup}"
        "size 30% 30%, ${pavucontrol_popup}"
        "float, ${blueman_popup}"
        "center ${blueman_popup}"
        "float, ${blueman_popup}"
        "size 30% 30%, ${blueman_popup}"
        "float, ${nm_popup}"
        "center ${nm_popup}"
        "float, ${nm_popup}"
        "size 30% 30%, ${nm_popup}"
        "float, title:^(.*Hyprshot.*)$"
      ];

      misc = {
        disable_hyprland_logo = true;
        disable_hyprland_qtutils_check = true;
        force_default_wallpaper = -1;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = false;
      };

    }; # End of settings.

    # Not needed anymore with UWSM?!
    # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
    #systemd.variables = ["--all"];
  };
}
