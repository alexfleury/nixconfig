{ pkgs, ... }: {
  gdstash = pkgs.callPackage ./gdstash.nix {};
  hyprshot-gui = pkgs.callPackage ./hyprshot_gui.nix {};
  search-mynixos = pkgs.callPackage ./search_mynixos.nix {};
  search-nixpkgs = pkgs.callPackage ./search_nixpkgs.nix {};
  zoom75-info = pkgs.callPackage ./zoom75_info.nix {};
}
