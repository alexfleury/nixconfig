{ pkgs, ... }: {
  imports =[
    ./disko-config.nix
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
    #kernelModules = [ ];
    #kernelParams = [ ];
  };

  networking = {
    hostName = "thinkflower";
    networkmanager.enable = true;
    networkmanager.dns = "dnsmasq";
    networkmanager.plugins = [ pkgs.networkmanager-openvpn ];
  };

  console.keyMap = "ca";
  i18n.defaultLocale = "en_CA.UTF-8";

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;
  services.automatic-timezoned.enable = true;
  services.libinput.enable = true;

  programs.bash.enable = true;

  fonts.packages = with pkgs; [
    corefonts
    vista-fonts
  ];

}
