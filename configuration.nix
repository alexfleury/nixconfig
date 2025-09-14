{ inputs, config, pkgs, ... }:
let
  hostname = "quantumflower";
  locale = "en_CA.UTF-8";
  name = "Alexandre";
  timezone = "America/Toronto";
  username = "alex";
in
{
  imports =[
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot = {
    initrd.kernelModules = [ "amdgpu" ];
    # The param "preempt=full" fixed buzzing sound in Hogwarts Legacy.
    kernelParams = [ "consoleblank=60" ];
    kernelModules = [ "sg" ];
    kernelPackages = pkgs.linuxPackages_zen;
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 5;
      consoleMode = "max";
      memtest86.enable = true;
    };
  };

  # Networking.
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
    networkmanager.dns = "dnsmasq";
    networkmanager.plugins = [ pkgs.networkmanager-openvpn ];
  };

  # Set locale-related settings.
  console.keyMap = "ca";
  i18n.defaultLocale = locale;
  time.timeZone = timezone;

  # Setting monitor backlight.
  hardware.i2c.enable = true;

  # GPU related settings.
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Bluetooth.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General.Experimental = true;
  };
  services.blueman.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
  };

  # Default shell is set to ZSH.
  programs.zsh.enable = true;
  environment = {
    shells = [ pkgs.zsh ];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };
    loginShellInit = ''
      if uwsm check may-start; then
        exec uwsm start hyprland-uwsm.desktop
      fi
    '';
    # Use gamescope in a new session.
    #[[ "$(tty)" = "/dev/tty2" ]] && gamescope -e --hdr-enabled -- steam -tenfoot &> /dev/null
    localBinInPath = true;
  };

  # Define a user account.
  users.users.${username} = {
    isNormalUser = true;
    description = name;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    amdgpu_top # use in waybar to get GPU clock.
    btrfs-progs
    ddcutil
    dysk # Get (pretty) info about mounted disks.
    e2fsprogs
    exfat
    exfatprogs
    git
    gparted
    gptfdisk
    jq # Json formatter.
    lact # Linux AMDGPU Controller
    networkmanagerapplet
    openrgb-with-all-plugins # RGB lighthing control.
    psmisc
    unzip
    vim
    wget
  ];

  # For lact.
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  # Enable hyprland.
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    withUWSM = true;
  };

  # Enable steam and gamescope.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.gamescope = {
    enable = true;
    # Apparently not true anymore.
    # https://github.com/NixOS/nixpkgs/issues/351516#issuecomment-2525575711
    capSysNice = true;
  };

  programs.thunar.enable = true;
  programs.xfconf.enable = true;

  # Mount, trash, and other functionalities.
  services.gvfs.enable = true;

  # Thumbnail support for images
  services.tumbler.enable = true;

  # Mount USB drives automatically.
  services.udisks2.enable = true;

  # Hardware RGBs.
  services.hardware.openrgb.enable = true;

  # Somehow needed for protonvpn-gui.
  services.gnome.gnome-keyring.enable = true;

  # Printing and automatic discovery of printers.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Security ann encryption.
  security = {
      pam.services.hyprlock = {};
      polkit.enable = true;
      rtkit.enable = true;
  };

  # Generate encrypted password.
  programs.gnupg.agent.enable = true;

  # QMK firmware service for keyboards.
  hardware.keyboard.qmk.enable = true;

  # Automatic ricing.
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

    # Local file.
    image = pkgs.requireFile {
      name = "a_street_with_buildings_and_signs.png";
      url = "https://github.com/dharmx/walls";
      sha256 = "277855097285c4824f7ed1ebbf1319ddf1ba9700364a338b6870fde81c44c54b";
    };
    #./wallpapers/a_street_with_buildings_and_signs.png;
    # Remote file.
    #image = "${wallpaperRepo}/first-collection/nixos.png";

    cursor = {
      package = pkgs.qogir-icon-theme;
      name = "Qogir Cursors";
      size = 28;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-mono;
        name = "Fira Mono Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.ubuntu-sans;
        name = "Ubuntu Sans Nerd Font";
      };
      serif = {
        package = pkgs.nerd-fonts.fira-code;
        name = "Fira Code Nerd Font";
      };

      sizes = {
        applications = 12;
        desktop = 12;
        popups = 10;
        terminal = 12;
      };

    };

    opacity = {
      applications = 1.0;
      desktop = 1.0;
      popups = 0.8;
      terminal = 0.8;
    };

    polarity = "dark";
  };

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    optimise.automatic = true;
  };

  # VMs config.
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "${username}" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  system.stateVersion = "24.05"; # Don't change this unless you know.
}
