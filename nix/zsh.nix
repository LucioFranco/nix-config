{ pkgs, ... }: {
    programs.zsh = {
        enable = true;

        shellAliases = {
            b = "brazil";
            bb = "brazil-build";
            bbb = "brazil-build-recursive";
        };
    

        # oh-my-zsh = {
        #     enable = true;
        #     plugins = ["git"];
        # };

        # initExtra = ''
        #     export PATH="$PATH:$HOME/.toolbox/bin:$HOME/.cargo/bin"

        #     ${pkgs.any-nix-shell}/bin/any-nix-shell zsh | source /dev/stdin
        # '';

        # plugins = [
        #     {
        #         # https://github.com/softmoth/zsh-vim-mode
        #         name = "zsh-vim-mode";
        #         file = "zsh-vim-mode.plugin.zsh";
        #         src = pkgs.fetchFromGitHub {
        #             owner = "softmoth";
        #             repo = "zsh-vim-mode";
        #             rev = "abef0c0c03506009b56bb94260f846163c4f287a";
        #             sha256 = "0cnjazclz1kyi13m078ca2v6l8pg4y8jjrry6mkvszd383dx1wib";
        #         };
        #     }
        # ];
    };
}