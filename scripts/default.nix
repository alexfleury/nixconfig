
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    (import ./bisync_proton.nix { inherit pkgs; } )
    (import ./copy_clipboard.nix { inherit pkgs; } )
    (import ./hyprsunset_widget.nix { inherit pkgs; } )
  ];
}