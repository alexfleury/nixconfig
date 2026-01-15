{
  lib,
  pkgs,
  ...
}:
let
  user = "alex";
  workspaces = {
    browser = "1";
    code = "2";
    chat = "3";
    steam = "4";
  };
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
      zed.enable = false;
    };
  };

  home.username = user;
  home.homeDirectory = "/home/${user}";

  # User packages.
  home.packages = with pkgs; [
    asunder                     # Ripping audio CDs.
    discord                     # Communication software.
    gnome-text-editor           # Simple text editor.
    handbrake                   # Transcoding videos.
    inkscape-with-extensions    # Vector image manip software.
    libreoffice                 # Office suite.
    nomacs                      # Image viewer.
    obsidian                    # Note application.
    kdePackages.okular          # KDE pdf viewer.
    papers                      # GNOME pdf viewer.
    #pastel                     # CLI to manipulate colors.
    pavucontrol                 # Manage sound through a panel.
    protonvpn-gui               # Proton VPN.
    #video2x                    # AI upscaling for videos.
    vlc                         # Reading videos.
    #yubioath-flutter           # Yubico authentification application.
  ];

  # Programs with options.
  programs.freetube.enable = true;
  programs.yt-dlp.enable = true;
  #programs.texlive = enable = true;

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
      "application/pdf" = [ "org.gnome.Papers.desktop" ];
      "image/*" = [ "nomacs.desktop" ];
      "video/*" = [ "vlc.desktop" ];
      "audio/*" = [ "vlc.desktop" ];
      "inode/directory" = [ "thunar.desktop" ];
      "text/plain" = [ "org.gnome.TextEditor.desktop" ];
    };
    userDirs.enable = true;
    userDirs.createDirectories = true;
  };

  wayland.windowManager.hyprland = {
    settings = {
      monitor = "DP-1, 3840x2160@239.99Hz, 0x0, 1.5, bitdepth, 10, vrr, 3, cm, auto";

      # Startup applications.
      exec-once = [
        "uwsm app -s b -- proton.vpn.app.gtk.desktop"
      ];

      input.kb_layout = "ca";

      "$mod" = "SUPER";
      bind = [
        "$mod, T, exec, uwsm app -- kitty.desktop"
        "$mod, E, exec, uwsm app -- thunar.desktop"
        "$mod, R, exec, rofi -show drun"
        "$mod, I, exec, uwsm app -- ${lib.getExe pkgs.hyprshot-gui}"
        "$mod, code:61, exec, uwsm app -- ${lib.getExe pkgs.zoom75-info}"
        "ALT, TAB, exec, rofi -show window -matching fuzzy"
        "CTRL_ALT, Delete, exec, rofi -show top"
        "SUPER, V, exec, ${lib.getExe pkgs.cliphist} list | ${lib.getExe pkgs.rofi} -dmenu -display-columns 2 | ${lib.getExe pkgs.cliphist} decode | ${pkgs.wl-clipboard}/bin/wl-copy"
      ];

      windowrule = [
        "match:title ^(Volume Control), float on center on size (monitor_w*0.3) (monitor_h*0.3)$"
        "match:title ^(Bluetooth Devices)$, float on center on size (monitor_w*0.3) (monitor_h*0.3)"
        "match:title ^(Network Connections)$, float on center on size (monitor_w*0.3) (monitor_h*0.3)"
        "match:title ^(.*Hyprshot.*)$, float on"
        "match:class ^(org.gnome.FileRoller)$, float on center on size (monitor_w*0.3) (monitor_h*0.3)"
        "match:class ^(firefox)$, workspace ${workspaces.browser}"
        "match:class ^(discord)$, workspace ${workspaces.chat}"
        "match:class ^(codium)$, workspace ${workspaces.code}"
        "match:class ^(steam)$, workspace ${workspaces.steam}"
      ];

    };
  };
}