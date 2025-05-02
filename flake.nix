{
  description = "Description for the project";

  inputs = {
    vim-config.url = "github:LucioFranco/vim-config";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nix-std.url = "github:chessai/nix-std";

    tinted-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    nix-github-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs = {
        # base16.follows = "base16";
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    starship-jj = {
      url = "gitlab:lanastara_foss/starship-jj";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      top@{ withSystem, ... }:
      {
        debug = true;

        imports = [
          inputs.git-hooks.flakeModule
          inputs.treefmt-nix.flakeModule
        ];
        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
        ];
        perSystem =
          ctx@{
            config,
            self',
            inputs',
            pkgs,
            system,
            ...
          }:
          {
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;

              overlays = [
                self.overlays.additions
                self.overlays.modifications
                self.overlays.unstable-packages
                inputs.vim-config.overlays.default
                inputs.starship-jj.overlays.default
                (final: prev: {
                  std = inputs.nix-std.lib;
                })
              ];
              config = {
                allowUnfree = true;
              };
            };

            formatter = config.treefmt.build.wrapper;
            checks.formatting = config.treefmt.build.check self;

            devShells = import ./nix/dev-shell.nix ctx;

            pre-commit = {
              check.enable = true;
              settings.hooks = {
                actionlint.enable = true;
                shellcheck.enable = true;
                ruff.enable = true;
                treefmt.enable = true;

                # TODO: re-enable this
                statix.enable = false;
                pyright.enable = false;
              };
            };

            treefmt = {
              projectRootFile = "flake.nix";
              flakeCheck = false; # Covered by git-hooks check
              programs = {
                nixfmt.enable = true;
                ruff-format.enable = true;
                shfmt = {
                  enable = true;
                  indent_size = 0;
                };
              };
            };
          };
        flake = {
          darwinConfigurations = import ./nix/darwin.nix top;
          nixosConfigurations = import ./nix/nixos.nix top;

          packages = import ./nix/packages.nix top;

          overlays = import ./nix/overlays.nix top;

          githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
            checks = inputs.nixpkgs.lib.recursiveUpdate self.checks self.packages;

          };
        };

      }
    );
}
