{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  # home.username = "lucio";
  # home.homeDirectory = "/home/lucio";

  imports = [
    inputs.ragenix.homeManagerModules.default
    ./atuin
    ./cargo.nix
    ./zsh.nix
    ./starship.nix
    ./git.nix
    ./fzf.nix
    ./nvim
    ./alacritty.nix
    ./tmux.nix
    ./zellij.nix
    ./jj.nix
  ];

  # nix = {
  #   registry = {
  #     # Register this flake itself on the registry
  #     me.flake = inputs.self;

  #     nixpkgs.flake = inputs.nixpkgs;
  #     # nixpkgs-stable.flake = inputs.nixpkgs-stable;
  #     # nixpkgs-master.flake = inputs.nixpkgs-master;
  #     home-manager.flake = inputs.home-manager;
  #     flake-utils.flake = inputs.flake-utils;
  #   };
  # };

  fonts.fontconfig.enable = true;

  home.sessionVariables = with pkgs; {
    # RA debug setting
    RA_PROFILE = "*@3>10";

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
    BINDGEN_EXTRA_CLANG_ARGS = "$(< ${stdenv.cc}/nix-support/libc-crt1-cflags) \n      $(< ${stdenv.cc}/nix-support/libc-cflags) \n      $(< ${stdenv.cc}/nix-support/cc-cflags) \n      $(< ${stdenv.cc}/nix-support/libcxx-cxxflags) \n      ${lib.optionalString stdenv.cc.isClang "-idirafter ${stdenv.cc.cc}/lib/clang/${lib.getVersion stdenv.cc.cc}/include"} \n      ${lib.optionalString stdenv.cc.isGNU "-isystem ${stdenv.cc.cc}/include/c++/${lib.getVersion stdenv.cc.cc} -isystem ${stdenv.cc.cc}/include/c++/${lib.getVersion stdenv.cc.cc}/${stdenv.hostPlatform.config} -idirafter ${stdenv.cc.cc}/lib/gcc/${stdenv.hostPlatform.config}/${lib.getVersion stdenv.cc.cc}/include"} \n    ";

    LIBRARY_PATH = "${pkgs.sqlite.out}/lib:${pkgs.iconv.out}/lib";
    TERM = "xterm-256color";
  };

  home.file.".terminfo".source = pkgs.symlinkJoin {
    name = "terminfo-dirs";
    paths = with pkgs; [
      (ncurses + "/share/terminfo")
    ];
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.toolbox/bin"
    "${config.home.homeDirectory}/.npm_global/bin"
    "${config.home.homeDirectory}/go/bin"
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.cargo/bin"
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

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
      config = {
        global = {
          warn_timeout = "30s";
        };
      };
    };

    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd"
        "cd"
      ];
    };
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [ batman ];
    };
  };

  home.packages = with pkgs; [
    # My custom tools
    window
    compare
    jj-github-pr
    spr

    # Common nix
    nixd
    nixfmt
    manix

    openssl
    git
    gh
    wget
    fh
    nix-output-monitor
    openssh
    coreutils
    findutils
    gawk
    gnugrep
    gnused
    gnutar
    gnutls
    ripgrep
    fd
    aws-iam-authenticator
    awscli2
    kubectl
    kubernetes-helm
    nerd-fonts.hack
    xh
    podman
    iconv
    eza
    mosh
  ];
}
