{ config, pkgs, ... }:

{
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./rofi.nix
    ./swaync.nix
    ./waybar.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitor settings.
      monitor = "DP-1,3840x2160@239.99Hz,0x0,1.5";
      xwayland.force_zero_scaling = true;

      # Common applications.
      "$terminal" = "kitty";
      "$fileManager" = "nautilus -w";
      "$menu" = "rofi -show drun";

      # Startup applications.
      exec-once = [
        "waybar"
        "hyprpaper"
        "hypridle"
        "swaync"
        "systemctl --user start hyprpolkitagent"
      ];

      env = [
        "XCURSOR_SIZE,28"
        "XCURSOR_THEME,Nordzy-cursors"
        "HYPRCURSOR_SIZE,28"
        "HYPRCURSOR_THEME,Nordzy-cursors"
      ];

      input.kb_layout = "ca";

      # Mod keys is the super key.
      "$mod" = "SUPER";

      # Common operations.
      bind = [
        "$mod, T, exec, $terminal"
        "$mod, Q, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, $fileManager"
        "$mod, V, togglefloating,"
        "$mod, R, exec, $menu"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
        "$mod, F, fullscreen"
        "$mod, L, exec, loginctl lock-session"
        "$mod SHIFT, w, exec, killall -SIGUSR1 .waybar-wrapped || waybar" # Toggle waybar.
        "$mod, ESCAPE, exec, sleep 1 && hyprctl dispatch dpms toggle"
      ]
      # Switch and move to workspaces 1 to 6.
      ++ (
        builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        )
        6)
      );
      # Utility keys.
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        #",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        #",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
      # Drag mouse.
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      general = {
        allow_tearing = false;
        border_size = 2;
        "col.active_border" = "rgb(${config.palette.accent0}) rgb(${config.palette.accent3}) 45deg";
        "col.inactive_border" = "rgb(${config.palette.grey})";
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

      misc = {
        disable_hyprland_logo = true;
        disable_hyprland_qtutils_check = true;
        force_default_wallpaper = -1;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = false;
      };

      gestures.workspace_swipe = false;

      windowrulev2 = [
        #"idleinhibit fullscreen, class:^(*)$"
        #"idleinhibit fullscreen, title:^(*)$"
        "idleinhibit fullscreen, fullscreen:1"
      ];

    };

    # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
    systemd.variables = ["--all"];
  };
}
