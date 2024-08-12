{ inputs, pkgs, config, lib, ... }: {
  # home.username = "lucio";
  # home.homeDirectory = "/home/lucio";

  imports = [
    ./zsh.nix
    ./starship.nix
    ./git.nix
    ./fzf.nix
    ./nvim
    ./alacritty.nix
    ./tmux.nix
    ./zellij.nix
  ];

  nix = {
    registry = {
      # Register this flake itself on the registry
      me.flake = inputs.self;

      nixpkgs.flake = inputs.nixpkgs;
      nixpkgs-stable.flake = inputs.nixpkgs-stable;
      nixpkgs-master.flake = inputs.nixpkgs-master;
      home-manager.flake = inputs.home-manager;
      flake-utils.flake = inputs.flake-utils;
    };
  };

  fonts.fontconfig.enable = true;

  home.sessionVariables = with pkgs; {
    # openssl config
    OPENSSL_DIR = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

    NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm_global";
    LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";

    # From: https://github.com/NixOS/nixpkgs/blob/1fab95f5190d087e66a3502481e34e15d62090aa/pkgs/applications/networking/browsers/firefox/common.nix#L247-L253
    # Set C flags for Rust's bindgen program. Unlike ordinary C
    # compilation, bindgen does not invoke $CC directly. Instead it
    # uses LLVM's libclang. To make sure all necessary flags are
    # included we need to look in a few places.
    BINDGEN_EXTRA_CLANG_ARGS = "$(< ${stdenv.cc}/nix-support/libc-crt1-cflags) \
      $(< ${stdenv.cc}/nix-support/libc-cflags) \
      $(< ${stdenv.cc}/nix-support/cc-cflags) \
      $(< ${stdenv.cc}/nix-support/libcxx-cxxflags) \
      ${lib.optionalString stdenv.cc.isClang "-idirafter ${stdenv.cc.cc}/lib/clang/${lib.getVersion stdenv.cc.cc}/include"} \
      ${lib.optionalString stdenv.cc.isGNU "-isystem ${stdenv.cc.cc}/include/c++/${lib.getVersion stdenv.cc.cc} -isystem ${stdenv.cc.cc}/include/c++/${lib.getVersion stdenv.cc.cc}/${stdenv.hostPlatform.config} -idirafter ${stdenv.cc.cc}/lib/gcc/${stdenv.hostPlatform.config}/${lib.getVersion stdenv.cc.cc}/include"} \
    ";

    LIBRARY_PATH = "${pkgs.sqlite.out}/lib:${pkgs.iconv.out}/lib";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.toolbox/bin"
    "${config.home.homeDirectory}/.npm_global/bin"
    "${config.home.homeDirectory}/go/bin"
    "${config.home.homeDirectory}/.local/bin"
  ];

  # Disable hm's darwin linking logic that conflicts with the custom
  # activation script below.
  #
  # Ref: https://github.com/nix-community/home-manager/issues/1341#issuecomment-1306148374
  disabledModules = [ "targets/darwin/linkapps.nix" ];

  programs.go.enable = true;
  programs.go.package = pkgs.go_1_22;

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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  home.packages = with pkgs; [
    libclang
    rustup
    # python312
    # python312Packages.pip
    # poetry
    protobuf
    openssl
    pkg-config
    git
    cmake
    gnumake
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

    #rust-analyzer

    ripgrep
    fd

    nixpkgs-fmt

    neovide

    helix
    zellij

    nodejs
    bun

    # pulumi
    # pulumiPackages.pulumi-language-python
    aws-iam-authenticator
    awscli2
    kubectl
    kubernetes-helm

    nodePackages.pyright

    nerdfonts

    sqlite
    tcl

    # http
    xh

    flyctl
    podman

    iconv

    wireguard-tools
  ] ++ lib.optionals (stdenv.isLinux) [
    clang
  ];
}
