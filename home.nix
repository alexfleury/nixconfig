{ config, pkgs, lib, ... }:
let
  username = "alex";
in
{
  imports = [
    ./user/cli/fastfetch.nix
    ./user/cli/git.nix
    ./user/cli/zsh.nix
    ./user/desktop/hyprland/hyprland.nix
    ./user/desktop/firefox.nix
    ./user/desktop/kitty.nix
    ./user/desktop/vscodium.nix
    ./user/desktop/udiskie.nix
  ];

  options = {
    palette = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
    };
    font = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {

    # User options.
    font = "Fira Code Nerd Font";
    palette = (import ./user/desktop/nord.nix);

    home.username = username;
    home.homeDirectory = "/home/${username}";

    home.packages = with pkgs; [
      amdgpu_top
      borgbackup
      discord
      geeqie
      hyprcursor
      hyprpolkitagent
      hyprshot
      hyprsunset
      jdk
      kitty
      libnotify
      libreoffice
      nautilus
      networkmanagerapplet
      pavucontrol
      rclone
      vlc
      yt-dlp
      zathura
    ];

    home.file = {
      ".local/bin" = {
        source = ./scripts;
        recursive = true;
      };
    };

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
    }; # End of gtk.

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
    }; # End of dconf.

    xdg = {
      enable = true;
      mime.enable = true;
      mimeApps.enable = true;
      mimeApps.defaultApplications = {
        "application/pdf" = "firefox.desktop";
        "image/*" = "geeqie.desktop";
        "video/*" = "vlc.desktop";
        "audio/*" = "vlc.desktop";
        "inode/directory" = "org.gnome.Nautilus.desktop";
        "text/plain" = "vscodium.desktop";
      };
      userDirs.enable = true;
      userDirs.createDirectories = true;
    }; # End of xdg.

    services.mpris-proxy.enable = true;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    home.stateVersion = "24.05"; # Don't change this unless you know.
  };
}
