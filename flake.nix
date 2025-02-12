{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgsStable.url = "nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./system/configuration.nix
          # inputs.stylix.nixosModules.stylix
        ];
      };
    };

    homeConfigurations = {
      eren = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit self inputs;};
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [./home];
      };
    };
  };
}
