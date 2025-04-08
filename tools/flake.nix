{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, nixpkgs }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        compare = pkgs.python3Packages.buildPythonApplication {
          pname = "compare";
          version = "0.1.0";

          src = ./.;
          format = "other";

          installPhase = ''
            mkdir -p $out/bin
            cp compare.py $out/bin/compare
            chmod +x $out/bin/compare
          '';
        };
      in
      {
        packages = {
          default = compare;
        };

        # apps.default = flake-utils.lib.mkApp {
        #   drv = compare;
        # };

        # apps.compare = flake-utils.lib.mkApp {
        #   drv = compare;
        #   exe = "compare";
        # };
      }
    );
}
