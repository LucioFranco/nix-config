{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];

  perSystem =
    {
      config,
      pkgs,
      system,
      self',
      lib,
      ...
    }:
    let
      nixvimPkgs = inputs.nixvim.legacyPackages.${system};
      nixvimLib = inputs.nixvim.lib.${system};
      nixvimModule = {
        inherit pkgs;
        module = import ../vim;
      };
    in
    {
      checks = {
        neovim = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
      };

      packages = {
        neovim = nixvimPkgs.makeNixvimWithModule nixvimModule;
      };

      overlayAttrs = {
        lucio-neovim = config.packages.neovim;
      };

      devShells.vim = pkgs.mkShell {
        name = "vim-config";

        nativeBuildInputs =
          with pkgs;
          [
            nixd
            statix
            config.treefmt.build.wrapper
          ]
          ++ (lib.attrValues config.treefmt.build.programs);

        shellHook = ''
          ${config.pre-commit.installationScript}
        '';
      };
    };
}
