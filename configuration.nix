{ config, pkgs, settings, ... }:

{
  imports =[
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
    consoleMode = "auto";
  };

  boot.kernelModules = [ "i2c-dev" "ddcci_backlight" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = settings.hostname;
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = settings.timezone;

  # Select internationalisation properties.
  i18n.defaultLocale = settings.locale;

  # Configure console keymap
  console.keyMap = "ca";

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  hardware.i2c.enable = true;

  # Bluetooth.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
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

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
  };

  programs.zsh.enable = true;
  environment = {
    shells = [ pkgs.zsh ];
    sessionVariables.NIXOS_OZONE_WL = "1";
    sessionVariables.MOZ_ENABLE_WAYLAND = "1";
    loginShellInit = ''
      [[ "$(tty)" = "/dev/tty1" ]] && exec Hyprland &> /dev/null
    '';
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${settings.username} = {
    isNormalUser = true;
    description = settings.name;
    extraGroups = [ "networkmanager" "wheel" "i2c" ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    btrfs-progs
    ddcutil
    git
    jq
    psmisc
    vim
    wget
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = [ pkgs.nerdfonts ];
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  #programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    extraPackages = with pkgs; [
      gamescope
    ];
    #gamescopeSession.enable = true;
  };

  services.udisks2.enable = true;

  security = {
      pam.services.hyprlock = {};
      polkit.enable = true;
      rtkit.enable = true;
  };

  services.gvfs.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.05"; # Don't change this unless you know.
}
