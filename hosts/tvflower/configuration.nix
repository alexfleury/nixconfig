{ pkgs, ... }: {
  imports =[
    ./disko-config.nix
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages;
    loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
  };

  networking = {
    hostName = "tvflower";
    networkmanager.enable = true;
    networkmanager.dns = "dnsmasq";
    networkmanager.plugins = [ pkgs.networkmanager-openvpn ];
  };

  console.keyMap = "ca";
  i18n.defaultLocale = "en_CA.UTF-8";
  time.timeZone = "America/Toronto";

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

  programs.bash.enable = true;

  environment.systemPackages = with pkgs; [
    # pass...
  ];

  fonts.packages = with pkgs; [
    corefonts
    vista-fonts
  ];
}
