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
    extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [ "i2c-dev" "ddcci_backlight" ];
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 5;
      consoleMode = "auto";
    };
  };

  # Networking.
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
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
    sessionVariables.NIXOS_OZONE_WL = "1";
    sessionVariables.MOZ_ENABLE_WAYLAND = "1";
    loginShellInit = ''
      [[ "$(tty)" = "/dev/tty1" ]] && exec Hyprland &> /dev/null
    '';
    localBinInPath = true;
  };

  # Define a user account.
  users.users.${username} = {
    isNormalUser = true;
    description = name;
    extraGroups = [ "networkmanager" "wheel" "i2c" "gamemode" ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    btrfs-progs
    ddcutil
    git
    jq
    openrgb-with-all-plugins
    psmisc
    vim
    wget
  ];

  # Install system-wide fonts.
  fonts = {
    enableDefaultPackages = true;
    packages = [ pkgs.nerdfonts ];
  };

  # Enable hyprland.
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  # Gaming-related options.
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # Services.
  services = {
    gvfs.enable = true;
    hardware.openrgb.enable = true;
    #printing.enable = true;
    udisks2.enable = true;
  };

  # Security ann encryption.
  security = {
      pam.services.hyprlock = {};
      polkit.enable = true;
      rtkit.enable = true;
  };

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
      options = "--delete-older-than 14d";
      persistent = true;
    };
  };

  system.stateVersion = "24.05"; # Don't change this unless you know.
}
