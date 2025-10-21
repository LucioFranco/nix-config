# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  dashlane-cli = pkgs.callPackage ./dashlane.nix { pkgs = pkgs; };
  window = pkgs.rustPlatform.buildRustPackage (
    let
      rustSrc = pkgs.fetchFromGitHub {
        owner = "matklad";
        repo = "window";
        rev = "1782327d7e897884ededd0c1cd377fc0a02c8152";
        sha256 = "sha256-EaopYWzVyWSrRjusczrLJgOsscnwHFqAlYhkggKdbLA=";
      };
    in
    {
      pname = "window";
      version = "0.0.0";

      src = rustSrc;

      cargoLock.lockFile = "${rustSrc}/Cargo.lock";
    }
  );

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

  jj-github-pr = pkgs.python3Packages.buildPythonApplication {
    pname = "jj-github-pr";
    version = "0.0.0";

    dependencies = with pkgs.python3Packages; [
      click
      pygithub
    ];

    src = ./tools;
    format = "other";

    installPhase = ''
      mkdir -p $out/bin
      cp jj_github_pr.py $out/bin/jj-github-pr
      chmod +x $out/bin/jj-github-pr
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

  linctl = pkgs.buildGoModule {
    pname = "linctl";
    version = "0.0.1";

    src = pkgs.fetchFromGitHub {
      owner = "dorkitude";
      repo = "linctl";
      rev = "b5996a38ba076ac97a7cc4a1dcc59cfbedbcf266";
      sha256 = "sha256-YIhI9pSkJ2w5eZQ+IyUTdD6risfc9L2j9ntQtmCJDd0=";
    };

    vendorHash = "sha256-Nt/V5IS0UY4ROh7epKmtAN3VDFJlCnqmKRk1AVRASgQ=";

    meta = with pkgs.lib; {
      description = "A comprehensive command-line interface for Linear's API";
      homepage = "https://github.com/dorkitude/linctl";
      license = licenses.mit;
    };
  };
}
