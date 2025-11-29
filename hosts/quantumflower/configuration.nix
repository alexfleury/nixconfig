{ pkgs, ... }: {
  imports =[
    ./hardware-configuration.nix
  ];

  boot = {
    initrd.kernelModules = [ "amdgpu" ];
    # The kernel param "preempt=full" fixed buzzing sound in Hogwarts Legacy.
    kernelParams = [ "consoleblank=60" ];
    # sg is for the usv CD drive.
    kernelModules = [ "sg" ];
    kernelPackages = pkgs.linuxPackages_latest;
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 5;
      consoleMode = "max";
      memtest86.enable = true;
    };
  };

  networking = {
    hostName = "quantumflower";
    networkmanager.enable = true;
    networkmanager.dns = "dnsmasq";
    networkmanager.plugins = [ pkgs.networkmanager-openvpn ];
  };
  # Somehow needed for protonvpn-gui.
  services.gnome.gnome-keyring.enable = true;

  console.keyMap = "ca";
  i18n.defaultLocale = "en_CA.UTF-8";
  time.timeZone = "America/Toronto";

  # Controlling monitor settings via software.
  hardware.i2c.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
    };
  };
  services.blueman.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  environment = {
    shells = [ pkgs.bash ];
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
    #[[ "$(tty)" = "/dev/tty2" ]] && \
    # gamescope -e --hdr-enabled -- steam -tenfoot &> /dev/null
    localBinInPath = true;
  };

  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  security = {
      # Note that PAM must be configured to enable hyprlock to perform
      # authentication. The package installed through home-manager will not be
      # able to unlock the session without this configurations.
      # https://mynixos.com/home-manager/option/programs.hyprlock.enable
      pam.services.hyprlock = {};
      # For realtime audio (used by pulseaudio or pipewire).
      rtkit.enable = true;
  };

  programs.bash.enable = true;

  environment.systemPackages = with pkgs; [
    btrfs-progs             # BTRFS management tools.
    lact                    # Linux AMDGPU Controller.
    networkmanagerapplet    # NetworkManager menu.
  ];

  fonts.packages = with pkgs; [
    corefonts
    vista-fonts
  ];

  extraServices = {
    gaming.enable = true;
    printing.enable = true;
    openrgb.enable = true;
    qmk.enable = true;
    stylix.enable = true;
    thunar.enable = true;
    vms.enable = true;
  };
}
