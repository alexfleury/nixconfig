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
  mkMenu = menu: let
    configFile = pkgs.writeText "config.yaml"
      (lib.generators.toYAML {} {
        anchor = "center";
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
      zed.enable = false;
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
    protonvpn-gui               # Proton VPN.
    #video2x                    # AI upscaling for videos.
    vlc                         # Reading videos.
    vesktop                     # Alternative discord app.
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
      "application/pdf" = [ "org.kde.okular.desktop" ];
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

      bind = [
        "SUPER, T, exec, uwsm app -- kitty.desktop"
        "SUPER, E, exec, uwsm app -- thunar.desktop"
        "SUPER, R, exec, rofi -show drun"
        "ALT, TAB, exec, rofi -show window -matching fuzzy"
        "CTRL_ALT, Delete, exec, rofi -show top"
        "SUPER, V, exec, ${lib.getExe pkgs.cliphist} list | ${lib.getExe pkgs.rofi} -dmenu -display-columns 2 | ${lib.getExe pkgs.cliphist} decode | ${pkgs.wl-clipboard}/bin/wl-copy"
        "SUPER, code:49, workspace, ${workspaces.browser}"
        "SUPER_SHIFT, code:49, movetoworkspacesilent, ${workspaces.browser}"
        "SUPER, code:16, workspace, ${workspaces.code}"
        "SUPER_SHIFT, code:16, movetoworkspacesilent, ${workspaces.code}"
        "SUPER, code:17, workspace, ${workspaces.chat}"
        "SUPER_SHIFT, code:17, movetoworkspacesilent, ${workspaces.chat}"
        "SUPER, code:18, workspace, ${workspaces.steam}"
        "SUPER_SHIFT, code:18, movetoworkspacesilent, ${workspaces.steam}"

        # Application shortcut as seen in https://www.vimjoyer.com/vid74-which-key.
        ("SUPER_SHIFT, D, exec, " + lib.getExe (mkMenu [
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
            key = "s";
            desc = "Screenshot";
            cmd = "uwsm app -- ${lib.getExe pkgs.hyprshot-gui}";
          }
          {
            key = "k";
            desc = "Zoom 75 keyboard cheat sheet";
            cmd = "uwsm app -- ${lib.getExe pkgs.zoom75-info}";
          }

        ]))
      ];

      bindl = [
        "SUPER, code:35, exec, ddcutil setvcp 10 + 10 --sleep-multiplier 0.13 --noverify --skip-ddc-checks --maxtries 1,1,1"
        "SUPER, code:51, exec, ddcutil setvcp 10 - 10 --sleep-multiplier 0.13 --noverify --skip-ddc-checks --maxtries 1,1,1"
      ];

      windowrule = [
        "match:title ^(Volume Control), float on center on size (monitor_w*0.3) (monitor_h*0.3)$"
        "match:title ^(Bluetooth Devices), float on center on size (monitor_w*0.3) (monitor_h*0.3)"
        "match:title ^(Network Connections), float on center on size (monitor_w*0.3) (monitor_h*0.3)"
        "match:title ^(.*Hyprshot.*)$, float on"
        "match:class ^(org.gnome.FileRoller)$, float on center on size (monitor_w*0.3) (monitor_h*0.3)"
        "match:class ^(firefox)$, workspace ${workspaces.browser}"
        "match:class ^(vesktop)$, workspace ${workspaces.chat}"
        "match:class ^(codium)$, workspace ${workspaces.code}"
        "match:class ^(steam)$, workspace ${workspaces.steam}"
      ];

    };
  };
}