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
      #pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
        system = system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            gdstash = final.callPackage ./packages/gdstash.nix { inherit pkgs; };
          })
        ];
      };
    in {
      nixosConfigurations = {
        "quantumflower" = lib.nixosSystem {
          inherit system pkgs;
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