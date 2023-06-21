{
  description = "Lucio's nix config";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    nur = {
      url = "github:nix-community/nur";
    };
  };

  outputs =
    { self
    , darwin
    , nixpkgs
    , home-manager
    , nixos-generators
    , nixos-hardware
    , nur
    , ...
    }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    {
      hosts = {
        workbook = {
          type = "darwin";
          hostPlatform = "aarch64-darwin";
        };

        wsl = {
          type = "homeManager";
          hostPlatform = "x86_64-linux";
        };

        # CI test hosts 
        gha-mac = {
          type = "darwin";
          hostPlatform = "x86_64-darwin";
        };
      };

      darwinConfigurations.workbook = darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [ ./nix/darwin.nix home-manager.darwinModules.home-manager ];
      };

      darwinConfigurations.gha-mac = darwin.lib.darwinSystem rec {
        system = "x86_64-darwin";
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

      nixosConfigurations = {
        vbox = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix/nixos.nix
            home-manager.nixosModules.home-manager
          ];
        };

        iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix/nixos.nix
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ];
        };

        thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nur.nixosModules.nur
            ./nix/nixos.nix
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen
          ];
        };
      };

      vbox = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        modules = [
          ./nix/nixos.nix
        ];

        format = "virtualbox";
      };

      pkgs = forAllSystems (localSystem:
        import nixpkgs {
          inherit localSystem;
          overlays = [ nur.overlay ];
          config.allowUnfree = true;
          config.allowAliases = true;
        });

      checks = forAllSystems (import ./nix/checks.nix inputs);
      devShells = forAllSystems (import ./nix/dev-shell.nix inputs);
      packages = forAllSystems (import ./nix/packages.nix inputs);
    };
}
