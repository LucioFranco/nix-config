{
  description = "Lucio's nix config";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, darwin, nixpkgs, home-manager }@inputs: {
    darwinConfigurations.workbook = darwin.lib.darwinSystem rec {
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      modules = [ ./nix/darwin.nix home-manager.darwinModules.home-manager ];
    };

    homeConfigurations.wsl = home-manager.lib.homeManagerConfiguration rec {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      modules = [ ./nix/wsl.nix ];
    };
  };
}
