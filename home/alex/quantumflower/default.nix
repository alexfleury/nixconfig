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
    ../../common
    ../../features/cli
    ../../features/desktop
    ../secrets.nix
    ./hyprland.nix
    ./waybar.nix
    ./xdg.nix
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
      ai.enable = true;
      firefox.enable = true;
      kitty.enable = true;
      stylix.enable = true;
      vscodium.enable = true;
      wayland.enable = true;
    };
  };

  home.username = user;
  home.homeDirectory = "/home/${user}";

  # User packages.
  home.packages = with pkgs; [
    asunder                     # Ripping audio CDs.
    gnome-text-editor           # Simple text editor.
    #inkscape-with-extensions    # Vector image manip software.
    libreoffice                 # Office suite.
    nomacs                      # Image viewer.
    obsidian                    # Note application.
    kdePackages.okular          # KDE pdf viewer.
    #pastel                     # CLI to manipulate colors.
    pavucontrol                 # Manage sound through a panel.
    #playerctl
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

  # Programs and services with options.
  programs.freetube.enable = true;
  programs.yt-dlp.enable = true;

  services = {
    mpris-proxy.enable = true;   # Play/pause on headphones.
    swayosd.enable = true;       # OSD window for common actions.
  };

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
}
