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
      settings = {
        system = "x86_64-linux";
        hostname = "quantumflower";
        timezone = "America/Toronto";
        locale = "en_CA.UTF-8";
        username = "alex";
        name = "Alexandre";
      };
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${settings.system};
    in {
      nixosConfigurations = {
        ${settings.hostname} = lib.nixosSystem {
          system = settings.system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${settings.username}.imports = [ ./home.nix ];
              home-manager.extraSpecialArgs = { inherit inputs; inherit settings;};
            }
          ];
          specialArgs = {
            inherit settings;
          };
        };
      };
      # Home-manager as standalone.
      #homeConfigurations = {
      #  ${settings.username} = home-manager.lib.homeManagerConfiguration {
      #    inherit pkgs;
      #    modules = [ ./home.nix ];
      #    extraSpecialArgs = {
      #      inherit settings;
      #    };
      #  };
      #};
    };
}