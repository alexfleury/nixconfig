{
  config,
  lib,
  pkgs,
  ...
}:
let
  user = "alex";
in {
  imports = [
    ../common
    ../features/cli
    ../features/desktop
    ./secrets.nix
  ];

  features = {
    cli = {
      bash.enable = true;
      borgmatic.enable = true;
      fastfetch.enable = true;
      git.enable = true;
      ssh.enable = true;
      starship.enable = true;
    };
    desktop = {
      ai.enable = false;
      firefox.enable = true;
      kitty.enable = true;
      makemkv.enable = true;
      stylix.enable = true;
      vscodium.enable = true;
      wayland.enable = true;
      zed.enable = true;
    };
  };

  home.username = user;
  home.homeDirectory = "/home/${user}";

  # User packages.
  home.packages = with pkgs; [
    asunder                     # Ripping audio CDs.
    gnome-text-editor           # Simple text editor.
    inkscape-with-extensions    # Vector image manip software.
    libreoffice                 # Office suite.
    nomacs                      # Image viewer.
    obsidian                    # Note application.
    kdePackages.okular          # KDE pdf viewer.
    #pastel                     # CLI to manipulate colors.
    pavucontrol                 # Manage sound through a panel.
    pdfarranger                 # Merge/split pdf documents and modify them.
    proton-vpn                  # Proton VPN.
    spotify                     # Streaming music.
    solaar                      # For Logitech Unifying Receiver
    ungoogled-chromium          # It supports HDR video playback.
    #video2x                    # AI upscaling for videos.
    vlc                         # Reading videos.
    vesktop                     # Alternative discord app.
    #yubioath-flutter           # Yubico authentification application.
  ];

  # Programs with options.
  programs.freetube.enable = true;
  programs.yt-dlp.enable = true;
  #programs.texlive.enable = true;

  # Play/pause on headphones.
  services.mpris-proxy.enable = true;

  home.sessionVariables = {
    BROWSER = "firefox";
    EDITOR = "vim";
    TERMINAL = "kitty";
  };

  # Fix for "Open Terminal Here" in Thunar.
  home.file = {
    ".config/xfce4/helpers.rc" = {
      text = ''TerminalEmulator=kitty'';
      executable = false;
    };
  };

  # Settings defaults.
  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps.enable = true;
    mimeApps.defaultApplications = {
      "application/pdf" = [ "org.kde.okular.desktop" ];
      "image/*" = [ "nomacs.desktop" ];
      "video/*" = [ "vlc.desktop" ];
      "audio/*" = [ "vlc.desktop" ];
      "inode/directory" = [ "thunar.desktop" ];
      "text/plain" = [ "org.gnome.TextEditor.desktop" ];
    };
    userDirs.enable = true;
    userDirs.createDirectories = true;
    userDirs.setSessionVariables = true;
  };

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

        bind = [
          (bind "${mod} + T" (dsp.exec_cmd "uwsm app -- kitty.desktop") { })
          (bind "${mod} + E" (dsp.exec_cmd "uwsm app -- thunar.desktop") { })
          (bind "${mod} + D" (dsp.exec_cmd "rofi -show drun") { })
          (bind "ALT + TAB" (dsp.exec_cmd "rofi -show window -matching fuzzy") { })
          (bind "CTRL + ALT" (dsp.exec_cmd "rofi -show top") { })
          (bind "${mod} + W" (dsp.exec_cmd "systemctl --user is-active --quiet wlsunset && systemctl --user stop wlsunset || systemctl --user start wlsunset") { })
          (bind "${mod} + G" (dsp.exec_cmd "uwsm app -- ${lib.getExe pkgs.hyprshot-gui}") { })
          (bind "${mod} + M" (dsp.exec_cmd "uwsm app -- ${lib.getExe pkgs.wayscriber} -a") { })
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
          # Gamescope.
          (bind "${mod} + B" (dsp.focus { workspace = workspaces.gamescope; }) { })
          (bind "${mod} + SHIFT + B" (dsp.window.move{ workspace = workspaces.gamescope; }){ })
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
            match.class = "^(.*Hyprshot.*)$";
            float = true;
            center = true;
          }
          {
            match.class = "^(org.gnome.FileRoller)$";
            float = true;
            center = true;
            size = "{monitor_w*0.3 monitor_h*0.3}";
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
                hl.exec_cmd(protonvpn-app)
              end
            '')
          ];
        };
      };
  };
}
