{ pkgs, ... }: {

  boot = {
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "splash"
      "consoleblank=60"
      "systemd.restore_state=1"
    ];
    kernelPackages = pkgs.linuxPackages_zen;
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 5;
      consoleMode = "max";
      memtest86.enable = true;
    };
  };

  networking = {
    hostName = "thinkflower";
    networkmanager.enable = true;
    networkmanager.dns = "dnsmasq";
    networkmanager.plugins = [ pkgs.networkmanager-openvpn ];
  };
  # Somehow needed for protonvpn-gui.
  services.gnome.gnome-keyring.enable = true;

  console.keyMap = "ca";
  i18n.defaultLocale = "en_CA.UTF-8";
  time.timeZone = "America/Toronto";

  hardware.enableAllFirmware = true;

  # Controlling monitor settings via software.
  hardware.i2c.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
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
        exec uwsm start hyprland.desktop
      fi
    '';
    localBinInPath = true;
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  services.libinput.enable = true;

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

  # Fix for running software in imperative mode.
  programs.nix-ld = {
    enable = true;
    libraries = pkgs.steam-run.args.multiPkgs pkgs;
  };

  environment.systemPackages = with pkgs; [
    btrfs-progs             # BTRFS management tools.
    networkmanagerapplet    # NetworkManager menu.
  ];

  # Fixes
  # Mount point '/boot' which backs the random seed file is world accessible,
  # which is a security hole!
  # https://discourse.nixos.org/t/nixos-install-with-custom-flake-results-in-boot-being-world-accessible/34555/17
  fileSystems."/boot".options = [ "umask=0077" "defaults" ];

  extraServices = {
    gaming.enable = true;
    printing.enable = true;
    thunar.enable = true;
  };
}
