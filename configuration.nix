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
    kernelModules = [ "sg" ];
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
      [[ "$(tty)" = "/dev/tty1" ]] && exec Hyprland &> /dev/null
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

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    amdgpu_top
    btrfs-progs
    ddcutil
    e2fsprogs
    exfat
    exfatprogs
    git
    gptfdisk
    jq # Json formatter.
    lact # Linux AMDGPU Controller
    mangohud # Vulkan and OpenGL overlay for monitoring FPS, temperatures, CPU/GPU load and more
    openrgb-with-all-plugins # RGB lighthing control.
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

  # Enable steam and gamescope.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.gamescope = {
    enable = true;
    # https://github.com/NixOS/nixpkgs/issues/351516#issuecomment-2525575711
    capSysNice = false;
  };

  # Remember ssh passphrase.
  programs.ssh = {
    startAgent = true;
  };

  # Services.
  services = {
    gvfs.enable = true;
    hardware.openrgb.enable = true;
    printing.enable = false;
    udisks2.enable = true;
  };

  # TODO: keyring unlocked at login?
  #services.gnome.gnome-keyring.enable = true;

  # Security ann encryption.
  security = {
      pam.services.hyprlock = {};
      polkit.enable = true;
      rtkit.enable = true;
  };

  # Generate encrupted password.
  programs.gnupg.agent = {
    enable = true;
  };

  # QMK firmware service for keyboards.
  hardware.keyboard.qmk.enable = true;

  # Nix-related options.
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
      persistent = true;
    };
  };

  system.stateVersion = "24.05"; # Don't change this unless you know.
}
