{ pkgs, config, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    verbose = true;
  };

  home-manager.users.luciofra = {
    home.stateVersion = "22.05";
    home.sessionVariables = {
      EDITOR = "vim";

      # openssl config
      OPENSSL_DIR = "${pkgs.openssl.dev}";
      OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
      OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    };

    home.sessionPath = [
      # "${config.home.homeDirectory}/.toolbox/bin"
      # "${config.home.homeDirectory}/.cargo/bin"
      "/Users/luciofra/.toolbox/bin"
    ];

    home.packages = with pkgs; [
      rnix-lsp
      nixpkgs-fmt
    ];

    imports = [
      ./zsh.nix
      ./starship.nix
      ./git.nix
      ./neovim.nix
      ./fzf.nix
    ];
  };
}
