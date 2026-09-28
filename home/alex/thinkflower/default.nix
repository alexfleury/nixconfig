{
  config,
  inputs,
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
    (inputs.import-tree.matchNot ".*/default\\.nix" ./.)
  ];

  features = {
    cli = {
      bash.enable = true;
      borgmatic.enable = false;
      dev.enable = true;
      fastfetch.enable = true;
      git.enable = true;
      ssh.enable = true;
      starship.enable = true;
    };
    desktop = {
      firefox.enable = true;
      #hypridle.enable = true;
      #hyprlock.enable = true;
      #hyprpaper.enable = true;
      kitty.enable = true;
      #rofi.enable = true;
      stylix.enable = true;
      vscodium.enable = true;
      #wlsunset.enable = true;
      #wayle.enable = true;
    };
  };

  home.username = user;
  home.homeDirectory = "/home/${user}";

  # User packages.
  home.packages = with pkgs; [
    gnome-text-editor           # Simple text editor.
    nomacs                      # Image viewer.
    #kdePackages.okular          # KDE pdf viewer.
    pavucontrol                 # Manage sound through a panel.
    proton-vpn                  # Proton VPN.
    spotify                     # Streaming music.
    vlc                         # Reading videos.
  ];

  # Programs and services with options.
  programs = {
    #freetube.enable = true;     # YT videos.
    #libreoffice.enable= true;   # Office suite.
    #vesktop.enable = true;      # Discord alternative.
    #yt-dlp.enable = true;       # CLI to download YT videos.
  };
  services = {
    mpris-proxy.enable = true;   # Play/pause on headphones.
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
