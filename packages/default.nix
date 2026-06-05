{ pkgs, ... }: {
  gdstash = pkgs.callPackage ./gdstash.nix {};
  hyprshot-gui = pkgs.callPackage ./hyprshot_gui.nix {};
  search-hm-options = pkgs.callPackage ./search_hm_options.nix {};
  search-nixpkgs = pkgs.callPackage ./search_nixpkgs.nix {};
  search-nix-options = pkgs.callPackage ./search_nix_options.nix {};
  zoom75-info = pkgs.callPackage ./zoom75_info.nix {};
}
