{ osConfig, ... }: {
  imports = [
    ./firefox.nix
    ./gaming.nix
    ./hyprland.nix
    ./kitty.nix
    ./makemkv.nix
    ./stylix.nix
    ./vscodium.nix
    ./wayland.nix
    ./zed.nix
  ];

  services.blueman-applet.enable = osConfig.services.blueman.enable;
}
