{
  withSystem,
  inputs,
  ...
}:
let
  inherit (inputs)
    self
    darwin
    home-manager
    nixpkgs
    ;
  inherit (nixpkgs) lib;
in

withSystem "aarch64-darwin" (
  {
    self',
    pkgs,
    system,
    ...
  }:
  {
    workbook = darwin.lib.darwinSystem rec {
      inherit pkgs system;

      specialArgs = {
        inherit inputs;
      };
      modules = [

        ../hosts/workbook.nix
        home-manager.darwinModules.home-manager
        {
          nix.registry = {
            p.flake = nixpkgs;
          };

          home-manager = {
            extraSpecialArgs.inputs = inputs;
            useGlobalPkgs = true;
            backupFileExtension = "hm-bak";
          };
        }
      ];
    };
  }
)
