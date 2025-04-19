{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
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
          packages.default = pkgs.hello;
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
              nixfmt-rfc-style.enable = true;
              ruff-format.enable = true;
              shfmt = {
                enable = true;
                indent_size = 0;
              };
            };
          };
        };
      flake = {
        githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
          checks = { inherit (self) checks; };
        };

      };
    };
}
