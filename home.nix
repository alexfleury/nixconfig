{ config, pkgs, lib, ... }:
let
  username = "alex";
in
{
  imports = [
    ./scripts
    ./user/desktop/hyprland
    ./user/cli/borgmatic.nix
    ./user/cli/fastfetch.nix
    ./user/cli/git.nix
    ./user/cli/ssh.nix
    ./user/cli/zsh.nix
    ./user/desktop/firefox.nix
    ./user/desktop/kitty.nix
    ./user/desktop/udiskie.nix
    ./user/desktop/vscodium.nix
    ./user/desktop/wlsunset.nix
  ];

  # User-related config.
  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [
    discord
    freetube
    geany
    kitty
    libreoffice
    gdstash # Custom package fro GDStash.
    #handbrake
    #makemkv
    nomacs # Image viewer.
    obsidian # Note application.
    pavucontrol
    proton-pass
    protonvpn-gui
    qmk
    qpdfview # PDF viewer.
    rclone
    #video2x-full # AI upscaling for videos.
    tldr
    vlc
    yt-dlp
    #yubioath-flutter # Yubico authentification application.
    # For Battle.net
    (wineWowPackages.full.override {
      wineRelease = "staging";
      mingwSupport = true;
    })
    winetricks
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.shellAliases = {
    ".." = "cd ..";
    sudo = "sudo ";
    neofetch = "fastfetch";
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps.enable = true;
    mimeApps.defaultApplications = {
      "application/pdf" = [ "qpdfview.desktop" ];
      "image/*" = [ "nomacs.desktop" ];
      "video/*" = [ "vlc.desktop" ];
      "audio/*" = [ "vlc.desktop" ];
      "inode/directory" = [ "thunar.desktop" ];
      "text/plain" = [ "codium.desktop" ];
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.05"; # Don't change this unless you know.
}
