{ withSystem, inputs, ... }:
let
  inherit (inputs) home-manager nixpkgs;
  inherit (nixpkgs) lib;
in
withSystem "x86_64-linux" (
  { system, pkgs, ... }:
  {
    wsl = lib.nixosSystem {
      inherit pkgs system;

      specialArgs = { inherit inputs; };

      modules = [
        ../hosts/wsl.nix
        home-manager.nixosModules.home-manager
        inputs.nixos-wsl.nixosModules.default
        inputs.ragenix.nixosModules.default
        # inputs.ragenix.homeManagerModules.default
        {
          home-manager.extraSpecialArgs.inputs = inputs;
          home-manager.useGlobalPkgs = true;
        }
      ];
    };
  }
)
