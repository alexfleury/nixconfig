{ config, pkgs, lib, settings, ... }:
{
  imports = [
    ./user/cli.nix
    ./user/hyprland.nix
    ./user/kitty.nix
    ./user/vscodium.nix
  ];

  options = {
    palette = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
    };
  };

  config = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home.username = settings.username;
    home.homeDirectory = "/home/${settings.username}";

    home.packages = with pkgs; [
      hyprcursor
      hyprshot
      kitty
      libnotify
      libreoffice
      nautilus
      neovim
    ];

    #home.file = {
    #};

    home.sessionVariables = {
      EDITOR = "vim";
    };

    home.shellAliases = {
      ".." = "cd ..";
      home-manager = "home-manager -b hm.bak";
      sudo = "sudo ";
    };

    programs.firefox.enable = true;

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

    palette = (import ./nord.nix);

    services.gammastep = {
      enable = true;
      latitude = "45.5019";
      longitude = "-73.5674";
      tray = false;
      temperature.day = 5500;
      temperature.night = 3700;
    };

    programs.git = {
      enable = true;
      userName = "alexfleury";
      userEmail = "28400108+alexfleury@users.noreply.github.com";
    };

    xdg.enable = true;
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    home.stateVersion = "24.05"; # Don't change this unless you know.
  };
}
