{
  inputs,
  lib,
  outputs,
  pkgs,
  ...
}:
let
  inherit (builtins) filter map toString;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix;
  autoImports = filter (hasSuffix ".nix") (
    map toString (filter (p: p != ./default.nix) (listFilesRecursive ./.))
  );
in {
  imports = autoImports;

  environment.systemPackages = with pkgs; [
    dysk          # Get (pretty) info about mounted disks.
    e2fsprogs     # Ext2 utilities.
    exfat         # exFat support.
    exfatprogs    # exFat utilities.
    gptfdisk      # Better tool for partionning disks.
    psmisc        # For fuse and proc file systems.
    unzip         # Unzipping archives.
    vim           # Vim editor.
    wget          # Download in CLI.
  ];

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs outputs;};
    #useGlobalPkgs = true; # There is a warning with overlays...
    useUserPackages = true;
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