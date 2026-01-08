{
  config,
  inputs,
  lib,
  pkgs,
  outputs,
  ...
}:
{
  # Import home-manager modules (agenix, stylix, and custom ones).
  imports = [
    inputs.agenix.homeManagerModules.default
    inputs.stylix.homeModules.stylix
    ]
    ++ builtins.attrValues outputs.homeModules;

  programs.home-manager.enable = true;

  # Next two blocks are there because of home-manager.useUserPackages = true.
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    config.allowUnfree = true;
  };
  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.dates = "weekly";
    clean.extraArgs = "--keep-since 14d --keep 3";
    flake = "${config.home.homeDirectory}/nixconfig";
  };

  home.stateVersion = "24.05"; # Don't change this unless you know.
}