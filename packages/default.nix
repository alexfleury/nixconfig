{ pkgs, ... }:
{
  gdstash = pkgs.callPackage ./gdstash.nix { inherit pkgs; };
  hyprshot-gui = pkgs.callPackage ./hyprshot_gui.nix { inherit pkgs; };
  zoom75-info = pkgs.callPackage ./zoom75_info.nix { inherit pkgs; };
}
