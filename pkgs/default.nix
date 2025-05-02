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

  # starship-jj = pkgs.rustPlatform.buildRustPackage (
  #   let
  #     rustSrc = pkgs.fetchFromGitLab {
  #       owner = "lanastara_foss";
  #       repo = "starship-jj";
  #       rev = "8eacf1f6704e285f8f26c4b522326c6172b3c9fe";
  #       sha256 = "";
  #     };
  #   in
  #   {
  #     pname = "starship-jj";
  #     version = "0.0.0";
  #
  #     src = rustSrc;
  #
  #     cargoLock.lockFile = "${rustSrc}/Cargo.lock";
  #   }
  # );

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
}
