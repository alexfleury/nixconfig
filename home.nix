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
    ./user/desktop/vscodium.nix
    ./user/desktop/udiskie.nix
  ];

  # User-related config.
  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [
    discord
    feh
    freetube
    geany
    kitty
    libreoffice
    gdstash
    kdePackages.okular
    limo
    makemkv
    nh
    obsidian
    pavucontrol
    proton-pass
    protonvpn-gui
    qmk
    rclone
    vlc
    yt-dlp
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    FLAKE = "/home/${username}/nixconfig";
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
      "application/pdf" = [ "org.kde.okular.desktop" ];
      "image/*" = [ "feh.desktop" ];
      "video/*" = [ "vlc.desktop" ];
      "audio/*" = [ "vlc.desktop" ];
      "inode/directory" = [ "org.kde.dolphin.desktop" ];
      "text/plain" = [ "geany.desktop" ];
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.05"; # Don't change this unless you know.
}
