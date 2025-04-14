{
  description = "Lucio's nix config";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/master"; };

    nixos-hardware = { url = "github:nixos/nixos-hardware"; };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

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
      inputs.flake-compat.follows = "flake-compat";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    nur = { url = "github:nix-community/nur"; };

    xdg-open-wsl = { url = "github:LucioFranco/xdg-open-wsl"; };

    crane.url = "github:ipetkov/crane";

    # tools = {
    #   url = "path:tools";
    #   inputs.crane.follows = "crane";
    #   inputs.flake-utils.follows = "flake-utils";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixos-wsl, darwin, nixpkgs, home-manager, nixos-generators
    , nixos-hardware, nur, ... }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in {
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
        # gha-mac = {
        #   type = "darwin";
        #   hostPlatform = "x86_64-darwin";
        # };
      };

      darwinConfigurations.workbook = darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        # pkgs = import nixpkgs {
        #   inherit system;
        #   config.allowUnfree = true;
        # };
        specialArgs = { inherit inputs; };
        modules = [

          ./nix/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.useGlobalPkgs = true;
          }
          {
            nixpkgs = { config.allowUnfree = true; };
            nix = { registry.nixpkgs.flake = nixpkgs; };
          }
        ];
      };

      # darwinConfigurations.gha-mac = darwin.lib.darwinSystem rec {
      #   system = "x86_64-darwin";
      #   pkgs = import nixpkgs {
      #     inherit system;
      #     config.allowUnfree = true;
      #   };
      #   modules = [ ./nix/darwin.nix home-manager.darwinModules.home-manager ];
      # };

      homeConfigurations.wsl = home-manager.lib.homeManagerConfiguration rec {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs.inputs = inputs;
        modules = [ ./nix/wsl.nix ];
      };

      nixosConfigurations = {
        wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix/nixos.nix
            home-manager.nixosModules.home-manager
            nixos-wsl.nixosModules.default
            { home-manager.extraSpecialArgs.inputs = inputs; }
          ];
        };
        # nixosConfigurations = {
        #   vbox = nixpkgs.lib.nixosSystem {
        #     system = "x86_64-linux";
        #     modules = [ ./nix/nixos.nix home-manager.nixosModules.home-manager ];
        #   };

        #   thinkpad = nixpkgs.lib.nixosSystem {
        #     system = "x86_64-linux";
        #     modules = [
        #       nur.nixosModules.nur
        #       ./nix/nixos.nix
        #       home-manager.nixosModules.home-manager
        #       nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen
        #     ];
        #   };
      };

      pkgs = forAllSystems (localSystem:
        import nixpkgs {
          inherit localSystem;
          # overlays = [ nur.overlay.default ];
          config.allowUnfree = true;
          config.allowAliases = true;
        });

      checks = forAllSystems (import ./nix/checks.nix inputs);
      devShells = forAllSystems (import ./nix/dev-shell.nix inputs);
      packages = forAllSystems (import ./nix/packages.nix inputs);
    };
}
