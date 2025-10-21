{ pkgs, ... }:
{
  # Define your custom packages here
  #  my-package = pkgs.callPackage ./my-package {};
  gdstash = pkgs.callPackage ./gdstash.nix { inherit pkgs; };
  hyprshot-gui = pkgs.callPackage ./hyprshot_gui.nix { inherit pkgs; };
}
