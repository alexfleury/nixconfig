{ config, pkgs, ... }:
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
    # The param "preempt=full" fixed buzzing sound in Hogwarts Legacy.
    kernelParams = [ "preempt=full" "consoleblank=60" ];
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 5;
      consoleMode = "auto";
      memtest86.enable = true;
    };
  };

  # Networking.
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
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
  hardware.pulseaudio.enable = false;
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
      [[ "$(tty)" = "/dev/tty1" ]] && exec Hyprland &> /dev/null
    '';
    localBinInPath = true;
  };

  # Define a user account.
  users.users.${username} = {
    isNormalUser = true;
    description = name;
    extraGroups = [ "wheel" "networkmanager" "gamemode" ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    btrfs-progs
    ddcutil
    e2fsprogs
    git
    gptfdisk
    jq
    openrgb-with-all-plugins
    psmisc
    vim
    wget
  ];

  # Install system-wide fonts.
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.hack
    ];
  };

  # Enable hyprland.
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.gamescope.enable = true;

  # Remember ssh passphrase.
  programs.ssh = {
    startAgent = true;
    #enableAskPassword = true;
    #askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";
  };
  #environment.variables = {
  #  SSH_ASKPASS_REQUIRE = "prefer";
  #};

  # Services.
  services = {
    gvfs.enable = true;
    hardware.openrgb.enable = true;
    #printing.enable = true;
    udisks2.enable = true;
  };

  #services.gnome.gnome-keyring.enable = true;

  # Security ann encryption.
  security = {
      pam.services.hyprlock = {};
      polkit.enable = true;
      rtkit.enable = true;
  };

  programs.gnupg.agent = {
    enable = true;
  };

  hardware.keyboard.qmk.enable = true;

  # Nix-related options.
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
      persistent = true;
    };
  };

  system.stateVersion = "24.05"; # Don't change this unless you know.
}
