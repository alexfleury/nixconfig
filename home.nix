{ config, pkgs, lib, ... }:
let
  username = "alex";
in
{
  imports = [
    ./scripts
    ./user/cli/borgmatic.nix
    ./user/cli/fastfetch.nix
    ./user/cli/git.nix
    ./user/cli/ssh.nix
    ./user/cli/zsh.nix
    ./user/desktop/hyprland/hyprland.nix
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
    makemkv
    nautilus
    networkmanagerapplet
    kdePackages.okular
    pavucontrol
    qmk
    vlc
    yt-dlp
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
      "application/pdf" = [ "okularApplication_pdf.desktop" ];
      "image/*" = [ "feh.desktop" ];
      "video/*" = [ "vlc.desktop" ];
      "audio/*" = [ "vlc.desktop" ];
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      "text/plain" = [ "geany.desktop" ];
    };
    userDirs.enable = true;
    userDirs.createDirectories = true;
  };

  # Play/pause on headphones.
  services.mpris-proxy.enable = true;

  stylix.iconTheme = {
    enable = true;
    package = pkgs.nordzy-icon-theme;
    dark = "Nordzy";
  };

  # Password manager in Linux.
  programs.password-store = {
    enable = true;
    package = pkgs.pass;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.05"; # Don't change this unless you know.

}
