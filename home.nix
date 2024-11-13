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
    home.username = settings.username;
    home.homeDirectory = "/home/${settings.username}";

    home.packages = with pkgs; [
      amdgpu_top
      geeqie
      hyprcursor
      hyprpolkitagent
      hyprshot
      hyprsunset
      kitty
      libnotify
      libreoffice
      nautilus
      neovim
      networkmanagerapplet
      pavucontrol
      rclone
      vlc
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
      neofetch = "fastfetch";
    };

    programs.firefox = {
      enable = true;
      policies = {
        HardwareAcceleration = true;
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };
      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
          settings = {
            "media.ffmpeg.vaapi.enabled" = true;
          };
        };
      };
    }; # End of programs.firefox.

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

    palette = (import ./nord.nix);

    programs.git = {
      enable = true;
      userName = "alexfleury";
      userEmail = "28400108+alexfleury@users.noreply.github.com";
      ignores = [
        # MacOS junk.
        ".DS_store"

        # Python compilation and cache.
        "*.pyc"
        "build"
        "dist"
        ".eggs"
        "*.egg-info"
        "__pycache__"
        ".ipynb_checkpoints"

        # Per repo gitignore.
        ".gitignore"

        # Data files.
        "*.hdf5"

        # VS Code workspace files.
        ".vscode"
        "*.code-workspace"
      ];
      extraConfig = {
        color.ui = true;
        fetch.prune = true;
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
    }; # End of programs.git.

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
        "text/plain" = "nvim.desktop";
      };
      userDirs.enable = true;
      userDirs.createDirectories = true;
    }; # End of xdg.

    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "never";
      settings = {
        device_config = [
          {
            device_file = "/dev/sda1";
            ignore = true;
          }
          {
            device_file = "/dev/sdb1";
            ignore = true;
          }
        ];
      };
    }; # End of services.udiskie

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    home.stateVersion = "24.05"; # Don't change this unless you know.
  };
}
