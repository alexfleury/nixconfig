{ config, pkgs, lib, ... }:
let
  username = "alex";
in
{
  imports = [
    ./user/desktop/hyprland
    ./user/cli/borgmatic.nix
    ./user/cli/dev.nix
    ./user/cli/fastfetch.nix
    ./user/cli/git.nix
    ./user/cli/ssh.nix
    ./user/cli/shell.nix
    ./user/desktop/firefox.nix
    ./user/desktop/kitty.nix
    ./user/desktop/vscodium.nix
    ./user/desktop/wlsunset.nix
  ];

  # User-related config.
  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [
    discord
    freetube
    kitty
    libreoffice
    gdstash # Custom package for GDStash.
    gnome-text-editor
    nomacs # Image viewer.
    obsidian # Note application.
    papers # GNOME pdf viewer.
    pavucontrol
    proton-pass
    protonvpn-gui
    qmk
    rclone
    texlive.combined.scheme-full
    tldr
    vlc
    yt-dlp
    # For Battle.net
    (wineWowPackages.full.override {
      wineRelease = "staging";
      mingwSupport = true;
    })
    winetricks
    #handbrake
    #makemkv
    #video2x-full # AI upscaling for videos.
    #yubioath-flutter # Yubico authentification application.
  ];

  home.sessionVariables = {
    BROWSER = "firefox";
    EDITOR = "vim";
    TERMINAL = "kitty";
  };

  home.file = {
    ".config/xfce4/helpers.rc" = {
      text = ''TerminalEmulator=kitty'';
      executable = false;
    };
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps.enable = true;
    mimeApps.defaultApplications = {
      "application/pdf" = [ "org.gnome.Papers.desktop" ];
      "image/*" = [ "nomacs.desktop" ];
      "video/*" = [ "vlc.desktop" ];
      "audio/*" = [ "vlc.desktop" ];
      "inode/directory" = [ "org.gnome.TextEditor.desktop" ];
      "text/plain" = [ "gnome-text-editor.desktop" ];
    };
    userDirs.enable = true;
    userDirs.createDirectories = true;
  };

  # Play/pause on headphones.
  services.mpris-proxy.enable = true;

  stylix.iconTheme = {
    enable = true;
    package = pkgs.dracula-icon-theme;
    dark = "Dracula";
  };

  # Password manager in Linux.
  programs.password-store = {
    enable = true;
    package = pkgs.pass;
  };

  # Vulkan and OpenGL overlay for monitoring FPS, temperatures, CPU/GPU load and more.
  programs.mangohud = {
    enable = true;
    settings = {
      mangoapp_steam = true;
    };
  };

  # Music player.
  #programs.rmpc.enable = true;

  # Video player.
  #programs.mpv.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.dates = "weekly";
    clean.extraArgs = "--keep-since 14d --keep 3";
    flake = "/home/${username}/nixconfig";
  };

  services.blueman-applet.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.05"; # Don't change this unless you know.
}
