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

  options = {
    font = lib.mkOption { type = lib.types.str; };
    palette = lib.mkOption { type = lib.types.attrsOf lib.types.str; };
    wallpaperPath = lib.mkOption { type = lib.types.path; };
  };

  config = {
    # Custom options.
    font = "Fira Code Nerd Font";
    palette = (import ./user/desktop/nord.nix);
    wallpaperPath = ./wallpapers/trees.jpg;

    # User-related config.
    home.username = username;
    home.homeDirectory = "/home/${username}";

    home.packages = with pkgs; [
      discord
      feh
      geany
      jdk # Java for GDStash.
      kitty
      libreoffice
      makemkv
      nautilus
      networkmanagerapplet
      kdePackages.okular
      pavucontrol
      protonvpn-gui
      protonvpn-cli_2
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

    # Theming and color.
    gtk = {
      enable = true;
      theme = {
        name = "Nordic";
        package = pkgs.nordic;
      };
      iconTheme = {
        name = "Nordzy";
        package = pkgs.nordzy-icon-theme;
      };
      cursorTheme = {
        name = "Nordzy-cursors";
        package = pkgs.nordzy-cursor-theme;
      };
      gtk2.configLocation = "${config.home.homeDirectory}/.gtkrc-2.0";
    };

    dconf = {
      settings = {
        "org/gnome/desktop/interface" = {
          gtk-theme = "${config.gtk.theme.name}";
          cursor-theme = "${config.gtk.cursorTheme.name}";
        };
        "org/gnome/desktop/wm/preferences" = {
          theme = "${config.gtk.theme.name}";
          button-layout = "";
        };
      };
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

    # Password manager in Linux.
    programs.password-store = {
      enable = true;
      package = pkgs.pass;
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    home.stateVersion = "24.05"; # Don't change this unless you know.
  };
}
