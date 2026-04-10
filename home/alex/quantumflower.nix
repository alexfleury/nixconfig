{
  config,
  lib,
  pkgs,
  ...
}:
let
  specialKey = "SUPER";
  user = "alex";
  workspaces = {
    # Class: workspace id.
    firefox = "1";
    codium = "2";
    vesktop = "3";
    steam = "4";
    gamescope = "5";
  };
  mkMenu = menu: let
    configFile = pkgs.writeText "config.yaml"
      (lib.generators.toYAML {} {
        anchor = "center";
        background = config.lib.stylix.colors.withHashtag.base00;
        color = config.lib.stylix.colors.withHashtag.base05;
        border = config.lib.stylix.colors.withHashtag.base0D;
        inherit menu;
      });
  in
    pkgs.writeShellScriptBin "my-menu" ''
      exec ${lib.getExe pkgs.wlr-which-key} ${configFile}
    '';

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
    #discord                    # Communication software.
    gnome-text-editor           # Simple text editor.
    #handbrake                  # Transcoding videos.
    inkscape-with-extensions    # Vector image manip software.
    libreoffice                 # Office suite.
    nomacs                      # Image viewer.
    obsidian                    # Note application.
    kdePackages.okular          # KDE pdf viewer.
    #papers                     # GNOME pdf viewer.
    #pastel                     # CLI to manipulate colors.
    pavucontrol                 # Manage sound through a panel.
    pdfarranger                 # Merge/split pdf documents and modify them.
    proton-vpn                  # Proton VPN.
    solaar                      # For Logitech Unifying Receiver
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
    settings = {
      monitor = "DP-1, 3840x2160@239.99Hz, 0x0, 1.5, bitdepth, 10, vrr, 3, cm, hdr, sdrbrightness, 1.2, sdrsaturation, 1.1";

      # Startup applications.
      exec-once = [
        "uwsm app -s b -- proton.vpn.app.gtk.desktop"
      ];

      input.kb_layout = "ca";

      workspace = map (v: "${v}, persistent:false") (builtins.attrValues workspaces);

      bind = [
        "${specialKey}, T, exec, uwsm app -- kitty.desktop"
        "${specialKey}, E, exec, uwsm app -- thunar.desktop"
        "${specialKey}, D, exec, rofi -show drun"
        "${specialKey}, W, exec, systemctl --user is-active --quiet wlsunset && systemctl --user stop wlsunset || systemctl --user start wlsunset"
        "ALT, TAB, exec, rofi -show window -matching fuzzy"
        "CTRL_ALT, Delete, exec, rofi -show top"
        "${specialKey}, Z, workspace, ${workspaces.firefox}"
        "${specialKey}_SHIFT, Z, movetoworkspacesilent, ${workspaces.firefox}"
        "${specialKey}, X, workspace, ${workspaces.codium}"
        "${specialKey}_SHIFT, X, movetoworkspacesilent, ${workspaces.codium}"
        "${specialKey}, C, workspace, ${workspaces.vesktop}"
        "${specialKey}_SHIFT, C, movetoworkspacesilent, ${workspaces.vesktop}"
        "${specialKey}, V, workspace, ${workspaces.steam}"
        "${specialKey}_SHIFT, V, movetoworkspacesilent, ${workspaces.steam}"
        "${specialKey}, B, workspace, ${workspaces.gamescope}"
        "${specialKey}_SHIFT, B, movetoworkspacesilent, ${workspaces.gamescope}"

        # Application shortcut as seen in https://www.vimjoyer.com/vid74-which-key.
        ("${specialKey}_SHIFT, D, exec, " + lib.getExe (mkMenu [
          {
            key = "c";
            desc = "Codium";
            cmd = "uwsm app -- codium.desktop";
          }
          {
            key = "d";
            desc = "Discord";
            cmd = "uwsm app -- vesktop.desktop";
          }
          {
            key = "f";
            desc = "Firefox";
            cmd = "uwsm app -- firefox.desktop";
          }
          {
            key = "k";
            desc = "Zoom 75 keyboard cheat sheet";
            cmd = "uwsm app -- ${lib.getExe pkgs.zoom75-info}";
          }
          {
            key = "s";
            desc = "Screenshot";
            cmd = "uwsm app -- ${lib.getExe pkgs.hyprshot-gui}";
          }
          {
            key = "w";
            desc = "Wayscriber";
            cmd = "uwsm app -- ${lib.getExe pkgs.wayscriber} -a";
          }
        ]))
      ];

      windowrule = [
        "match:title ^(Volume Control), float on center on size monitor_w*0.3 monitor_h*0.3$"
        "match:class .blueman-manager-wrapped, float on center on size monitor_w*0.3 monitor_h*0.3"
        "match:title ^(Network Connections), float on center on size monitor_w*0.3 monitor_h*0.3"
        "match:title ^(.*Hyprshot.*)$, float on"
        "match:class ^(org.gnome.FileRoller)$, float on center on size (monitor_w*0.3) (monitor_h*0.3)"
      ]
      ++ lib.mapAttrsToList
        (name: value: "match:class ^(${name})$, workspace ${value}") workspaces;
    };
  };
}
