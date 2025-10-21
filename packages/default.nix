{ pkgs, ... }:

{
  gdstash = pkgs.callPackage ./gdstash.nix { inherit pkgs; };
  hyprshot-gui = pkgs.callPackage ./hyprshot_gui.nix { inherit pkgs; };
  search-mynixos = pkgs.callPackage ./search_mynixos.nix { inherit pkgs; };
  search-nixpkgs = pkgs.callPackage ./search_nixpkgs.nix { inherit pkgs; };
  zoom75-info = pkgs.callPackage ./zoom75_info.nix { inherit pkgs; };
}
