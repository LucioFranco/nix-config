# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  dashlane-cli = pkgs.callPackage ./dashlane.nix { pkgs = pkgs; };
  linear-cli = pkgs.callPackage ./linear-cli.nix { pkgs = pkgs; };

  n = pkgs.rustPlatform.buildRustPackage (
    let
      rustSrc = ./tools/n;
    in
    {
      pname = "n";
      version = "0.0.0";

      src = rustSrc;

      cargoLock.lockFile = "${rustSrc}/Cargo.lock";
    }
  );

  compare = pkgs.python3Packages.buildPythonApplication {
    pname = "compare";
    version = "0.0.0";

    src = ./tools;
    format = "other";

    installPhase = ''
      mkdir -p $out/bin
      cp compare.py $out/bin/compare
      chmod +x $out/bin/compare
    '';
  };

  xdg-open-wsl = pkgs.rustPlatform.buildRustPackage (
    let
      rustSrc = ./tools/xdg-open-wsl;
    in
    {
      pname = "xdg-open";
      version = "0.0.0";

      src = rustSrc;

      cargoLock.lockFile = "${rustSrc}/Cargo.lock";
    }
  );

}
