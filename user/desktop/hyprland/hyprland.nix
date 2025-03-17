{ config, pkgs, ... }:

let
  blueman_popup = "class:^(.blueman-manager-wrapped)$ title:^(Bluetooth Devices)$";
  nm_popup = "class:^(nm-connection-editor)$ title:^(Network Connections)$";
  pavucontrol_popup = "class:^(org.pulseaudio.pavucontrol)$ title:^(Volume Control)$";
in
{
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./rofi.nix
    ./swaync.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    hyprcursor
    hyprpolkitagent
    hyprshot
    hyprsunset
    playerctl
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    #plugins = with pkgs; [
    #  hyprlandPlugins.hyprbars
    #];

    settings = {
      # Monitor settings.
      monitor = "DP-1,3840x2160@239.99Hz,0x0,1.5,bitdepth,10";
      xwayland.force_zero_scaling = true;

      # Common applications.
      "$terminal" = "kitty";
      "$fileManager" = "nautilus -w";
      "$menu" = "rofi -show drun";

      # Startup applications.
      exec-once = [
        "${pkgs.waybar}/bin/waybar"
        "${pkgs.hyprpaper}/bin/hyprpaper"
        "${pkgs.hypridle}/bin/hypridle"
        "${pkgs.swaynotificationcenter}/bin/swaync"
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
      "$modd" = "SHIFT";

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
        "$mod $modd, W, exec, killall -SIGUSR1 .waybar-wrapped || ${pkgs.waybar}/bin/waybar" # Toggle waybar.
        "$mod, ESCAPE, exec, sleep 1 && hyprctl dispatch dpms toggle"
        "$mod, I, exec, ${pkgs.hyprshot}/bin/hyprshot -m region"
      ]
      # Switch and move to workspaces 1 to 6.
      ++ (
        builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod $modd, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        )
        6)
      );
      # Utility keys.
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
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
        #"col.active_border" = "rgb(${config.palette.accent0}) rgb(${config.palette.accent3}) 45deg";
        #"col.inactive_border" = "rgb(${config.palette.grey})";
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
        vrr = 2; # VRR in fullsreen mode only.
      };

      gestures.workspace_swipe = false;

      workspace = (
        builtins.concatLists (
          builtins.genList (i:
          let ws = i+1;
          in [
            "${toString ws}, persistent:true"
          ])
        6)
      );

      windowrulev2 = [
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
      ];

      #plugin = {
      #  hyprbars = {
      #    # example config
      #    bar_height = 20;

          # example buttons (R -> L)
          # hyprbars-button = color, size, on-click
      #    hyprbars-button = [
      #      "rgb(ff4040), 10, 󰖭, hyprctl dispatch killactive"
      #      "rgb(eeee11), 10, , hyprctl dispatch fullscreen 1"
      #    ];
      #  };
      #};

    }; # End of settings.

    # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
    systemd.variables = ["--all"];
  };
}
