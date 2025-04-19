{
  description = "My custom tools that I include in my home-manager config";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # crane.url = "github:ipetkov/crane";
    # flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.follows = "nixpkgs";
    flake-utils.follows = "flake-utils";
    crane.follows = "crane";
  };

  outputs =
    {
      crane,
      flake-utils,
      nixpkgs,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;
        craneLib = crane.mkLib pkgs;

        merge = attrs: lib.foldl' lib.recursiveUpdate { } attrs;

        buildPython = name: {
          name = pkgs.python3Packages.buildPythonApplication {
            pname = name;
            version = "0.1.0";

            src = ./.;
            format = "other";

            installPhase = ''
              mkdir -p $out/bin
              cp ${name}.py $out/bin/${name}
              chmod +x $out/bin/${name}
            '';
          };
        };

        buildRust = name: {
          name = craneLib.buildPackage {
            src = craneLib.cleanCargoSource ./${name};
          };
        };

        window = {
          window = craneLib.buildPackage {
            src = pkgs.fetchFromGitHub {
              owner = "LucioFranco";
              repo = "window";
              rev = "579952b72cc04a4fe0f286f73c0785112c976083";
              sha256 = "sha256-gHMWrzXAnreDNtvx9H0EMbmHx7Eik47LIGCy2oNGS6g=";
            };
          };
        };

        tools = merge [
          (buildRust "n")
          (buildPython "compare")
          window
        ];
      in
      {
        packages = tools;
        checks = tools;

        devShells.default = pkgs.mkShell { packages = with pkgs; [ rustup ]; };
      }
    );
}
