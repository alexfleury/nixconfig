{
  inputs,
  lib,
  outputs,
  pkgs,
  ...
}:
{
  imports = [
    ./extraServices
    ./users
  ];

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs outputs;};
    useGlobalPkgs = true;
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    config.allowUnfree = true;
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [
        "root"
        "alex"
      ];
      warn-dirty = false;
    };
    optimise.automatic = true;
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
  };

  users.defaultUserShell = pkgs.bash;

  system.stateVersion = "24.05"; # Don't change this unless you know.
}