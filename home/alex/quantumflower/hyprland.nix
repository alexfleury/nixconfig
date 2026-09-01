{
  lib,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    settings =
      let
        workspaces = {
          # Class: workspace id.
          firefox = "1";
          codium = "2";
          vesktop = "3";
          steam = "4";
          gamescope = "5";
          spotify = "6";
        };
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
          exec_cmd = cmd: mkLuaInline ''hl.dsp.exec_cmd("${cmd}")'';
          focus = arg: mkLuaInline "hl.dsp.focus(${toLua { } arg})";
          window = {
            move = arg: mkLuaInline "hl.dsp.window.move(${toLua { } arg})";
          };
        };
        mod = "SUPER";
      in
      {
        config = {
          input = {
            kb_layout = "ca";
            kb_variant = "";
            follow_mouse = 2;
          };
        };

        monitor = [
          {
            output = "DP-1";
            mode = "3840x2160@240";
            position = "0x0";
            scale = 1.5;
            bitdepth = 10;
            cm = "hdr";
            sdrbrightness = 1.2;
            sdrsaturation = 1.1;
            vrr = 2;
          }
        ];

        workspace_rule = map (v: { workspace = "${v}"; persistent = false; }) (builtins.attrValues workspaces);

        bind = let
            audioPlay = dsp.exec_cmd "swayosd-client --playerctl play-pause";
            audioPrev = dsp.exec_cmd "swayosd-client --playerctl prev";
            audioNext = dsp.exec_cmd "swayosd-client --playerctl next";
            audioOutMute = dsp.exec_cmd "swayosd-client --output-volume mute-toggle";
            audioInMute = dsp.exec_cmd "swayosd-client --input-volume mute-toggle";
            audioVolDown = dsp.exec_cmd "swayosd-client --output-volume -2";
            audioVolUp = dsp.exec_cmd "swayosd-client --output-volume +2";
          in [
          (bind "${mod} + T" (dsp.exec_cmd "uwsm app -- kitty.desktop") { })
          (bind "${mod} + E" (dsp.exec_cmd "uwsm app -- thunar.desktop") { })
          (bind "${mod} + D" (dsp.exec_cmd "rofi -show drun") { })
          (bind "ALT + TAB" (dsp.exec_cmd "rofi -show window -matching fuzzy") { })
          (bind "CTRL + ALT" (dsp.exec_cmd "rofi -show top") { })
          (bind "${mod} + W" (dsp.exec_cmd "systemctl --user is-active --quiet wlsunset && systemctl --user stop wlsunset || systemctl --user start wlsunset") { })
          (bind "${mod} + I" (dsp.exec_cmd "uwsm app -- ${lib.getExe pkgs.hyprshot-gui}") { })
          (bind "${mod} + SHIFT + I" (dsp.exec_cmd "uwsm app -- ${lib.getExe pkgs.wayscriber} -a") { })
          (bind "CAPS + Caps_Lock" (dsp.exec_cmd "swayosd-client --caps-lock") { release = true; })
          # Firefox.
          (bind "${mod} + Z" (dsp.focus { workspace = workspaces.firefox; }) { })
          (bind "${mod} + SHIFT + Z" (dsp.window.move{ workspace = workspaces.firefox; }){ })
          # Codium.
          (bind "${mod} + X" (dsp.focus { workspace = workspaces.codium; }) { })
          (bind "${mod} + SHIFT + X" (dsp.window.move{ workspace = workspaces.codium; }){ })
          # Discord / Vesktop.
          (bind "${mod} + C" (dsp.focus { workspace = workspaces.vesktop; }) { })
          (bind "${mod} + SHIFT + C" (dsp.window.move{workspace = workspaces.vesktop;}){ })
          # Steam.
          (bind "${mod} + V" (dsp.focus { workspace = workspaces.steam; }) { })
          (bind "${mod} + SHIFT + V" (dsp.window.move{ workspace = workspaces.steam; }){ })
          # Gaming (gamescope).
          (bind "${mod} + B" (dsp.focus { workspace = workspaces.gamescope; }) { })
          (bind "${mod} + SHIFT + B" (dsp.window.move{ workspace = workspaces.gamescope; }){ })
          # Music player.
          (bind "${mod} + M" (dsp.focus { workspace = workspaces.spotify; }) { })
          (bind "${mod} + SHIFT + M" (dsp.window.move{ workspace = workspaces.spotify; }){ })
          # Media controls.
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
        ];

        window_rule = [
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
            center = true;
            size = "{monitor_w*0.3 monitor_h*0.3}";
          }
          {
            match.class = "^(libreoffice.*)$";
            suppress_event = "maximize";
          }
        ]
        ++ lib.mapAttrsToList
          (name: value: { match.class = "^(${name})$"; workspace = "${value}"; }) workspaces;

        on = {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''
              function()
                hl.dispatch(hl.dsp.focus({ workspace = 11 }))
                hl.exec_cmd("protonvpn-app")
              end
            '')
          ];
        };
      };
  };
}
