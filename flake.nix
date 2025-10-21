{
  description = "Flake for flower";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ...} @ inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
        config.allowUnfree = true;
        overlays = [
          (import ./overlays { inherit inputs; }).additions
          (import ./overlays { inherit inputs; }).modifications
        ];
      };
    in {
      nixosConfigurations = {
        "quantumflower" = lib.nixosSystem {
          inherit system pkgs;
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = { inherit pkgs inputs; };
              home-manager.users."alex".imports = [ ./home.nix ];
            }
            inputs.stylix.nixosModules.stylix
          ];
        };
      };
    };
}
