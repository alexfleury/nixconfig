{
  description = ''
    Based on the https://code.m3ta.dev/m3tam3re structure.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    agenix,
    disko,
    home-manager,
    nixpkgs,
    stylix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    # Extend the lib library with custom functions.
    lib = nixpkgs.lib.extend (final: prev: {
      autoImports = import ./lib/autoImports.nix { lib = prev; };
    });
  in {
    packages =
      forAllSystems (system: import ./packages nixpkgs.legacyPackages.${system});
    overlays = import ./overlays;
    homeModules = import ./modules/home-manager;
    nixosConfigurations = {
      quantumflower = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs lib outputs;};
        modules = [
          ./hosts/quantumflower
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          agenix.nixosModules.default
        ];
      };
      tvflower = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs lib outputs;};
         system = "x86_64-linux";
        modules = [
          ./hosts/tvflower
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          agenix.nixosModules.default
          disko.nixosModules.disko
        ];
      };
    };
    # Using standalone home-manager.
    #homeConfigurations = {
    #  "alex@quantumflower" = home-manager.lib.homeManagerConfiguration {
    #    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    #    extraSpecialArgs = {inherit inputs outputs;};
    #    modules = [./home/alex/quantumflower.nix];
    #  };
    #};
  };
}
