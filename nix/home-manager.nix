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
            OPENSSL_DIR="${pkgs.openssl.dev}";
            OPENSSL_LIB_DIR="${pkgs.openssl.out}/lib";
            OPENSSL_INCLUDE_DIR="${pkgs.openssl.dev}/include";
            PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig";
        };

        home.sessionPath = [
            # "${config.home.homeDirectory}/.toolbox/bin"
            # "${config.home.homeDirectory}/.cargo/bin"
            "/Users/luciofra/.toolbox/bin"
        ];

        imports = [
            ./zsh.nix
            ./starship.nix
            ./git.nix
            ./neovim.nix
            # TODO: For some reason this doesn't work?
            #./fzf.nix
        ];

        programs.fzf = {
            enable = true;
            defaultCommand = "rg --files --hidden --glob !.git";
            fileWidgetCommand = "rg --files --hidden --glob !.git";
            changeDirWidgetCommand = "fd --type d";
        };
    };
}
