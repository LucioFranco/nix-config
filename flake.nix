{
  description = "Descriptihome.atuin.on for the project";

  nixConfig = {
    extra-trusted-substituters = [
      "https://luciofranco-nix-config.cachix.org"
      "https://luciofranco-vim-config.cachix.org"
    ];
    extra-trusted-public-keys = [
      "luciofranco-nix-config.cachix.org-1:thnuvxy1yQPda8HSo8vRHauactm+/wWdwLKoR+XXflQ="
      "luciofranco-vim-config.cachix.org-1:YdHNe6sVl60hQpxA7QwHSesd1CUi4idCOhw1yUo2FZ0="
    ];
  };

  inputs = {
    vim-config.url = "github:LucioFranco/vim-config";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nix-std.url = "github:chessai/nix-std";

    ragenix.url = "github:yaxitech/ragenix";

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

    jujutsu = {
      url = "github:jj-vcs/jj";
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
      top@{ withSystem, lib, ... }:
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
            pkgs,
            config,
            system,
            ...
          }:
          {
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;

              overlays = [
                inputs.vim-config.overlays.default
                inputs.starship-jj.overlays.default
                inputs.ragenix.overlays.default
                inputs.jujutsu.overlays.default
                (final: prev: {
                  std = inputs.nix-std.lib;
                })

                self.overlays.additions
                self.overlays.modifications
                self.overlays.unstable-packages
              ];
              config = {
                allowUnfree = true;
              };
            };

            packages.starship-jj = pkgs.starship-jj;

            formatter = config.treefmt.build.wrapper;
            checks.formatting = config.treefmt.build.check self;

            devShells = import ./nix/dev-shell.nix ctx;

            packages = {
              inherit (pkgs) nix-fast-build;
            };

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
                nixfmt = {
                  enable = true;
                  package = pkgs.nixfmt;
                };
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

          githubActions = inputs.nix-github-actions.lib.mkGithubMatrix (
            let
              filterPkgs = (
                allowedNames: packages:
                lib.mapAttrs (_system: pkgs: lib.filterAttrs (name: _: lib.elem name allowedNames) pkgs) packages
              );
              packages = [
                "wsl"
                "workbook"
                "formatting"
                "pre-commit"
              ];
            in
            {
              checks = filterPkgs packages (lib.recursiveUpdate self.checks self.packages);
            }
          );
        };
      }
    );
}
