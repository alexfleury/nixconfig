{
  description = "Flake for flower";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ...}:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        "quantumflower" = lib.nixosSystem {
          system = system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users."alex".imports = [ ./home.nix ];
            }
          ];
        };
      };
    };
}