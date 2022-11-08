{ pkgs, config, lib, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    verbose = true;
  };

  home-manager.users.luciofra = { lib, config, ... }: {
    home.stateVersion = "22.05";

    imports = [
      ./zsh.nix
      ./starship.nix
      ./git.nix
      ./fzf.nix
      ./nvim
      ./alacritty.nix
      ./tmux.nix
    ];

    home.sessionVariables = {
      EDITOR = "vim";

      # openssl config
      OPENSSL_DIR = "${pkgs.openssl.dev}";
      OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
      OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    };

    home.sessionPath = [
      "${config.home.homeDirectory}/.toolbox/bin"
    ];


    # Disable hm's darwin linking logic that conflicts with the custom
    # activation script below.
    #
    # Ref: https://github.com/nix-community/home-manager/issues/1341#issuecomment-1306148374
    disabledModules = [ "targets/darwin/linkapps.nix" ];

    # Home manager will symlink apps to ~/Applications/Home Manager Apps/ but
    # MacOS spotlight doesn't understand symlinks so instead we will just copy.
    #
    # Ref: https://github.com/nix-community/home-manager/issues/1341#issuecomment-1190875080
    home.activation = lib.mkIf pkgs.stdenv.isDarwin {
      copyApplications =
        let
          apps = pkgs.buildEnv {
            name = "home-manager-applications";
            paths = config.home.packages;
            pathsToLink = "/Applications";
          };
        in
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          baseDir="$HOME/Applications/Home Manager Apps"
          if [ -e "$baseDir" ]; then
            echo "Removing $baseDir"
            rm -rf "$baseDir" || rm -rf "$baseDir"
          fi
          mkdir -p "$baseDir"
          for appFile in ${apps}/Applications/*; do
            target="$baseDir/$(basename "$appFile")"
            $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
            $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
          done
        '';
    };

    home.packages =
      with pkgs;
      [
        rustup
        python38
        protobuf
        openssl
        pkg-config
        git
        cmake
        ninja
        gh
        nodePackages.conventional-changelog-cli
        wget
        autoconf
        automake
        autoconf-archive
        libtool
        unzip
        m4

        coreutils
        findutils
        gawk
        gnugrep
        gnused
        gnutar
        gnutls

        rust-analyzer

        ripgrep
        fd

        rnix-lsp
        nixpkgs-fmt
      ];
  };
}
