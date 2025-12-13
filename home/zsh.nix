{ pkgs, config, ... }:
{
  programs.zsh = {
    enable = true;

    shellAliases = {
      cat = "bat";
      cls = "clear";
      l = "ls";
      la = "ls --all";
      ls = "eza --binary --header --long";
      man = "batman";
      http = "xh";
      nvim-dev = "${config.home.homeDirectory}/code/nix-config/result/bin/nvim";
      nvimd = "${config.home.homeDirectory}/code/nix-config/result/bin/nvim";
      direnv-reload = "nix-direnv-reload";
      shell-reload = "unset __HM_SESS_VARS_SOURCED && source ~/.nix-profile/etc/profile.d/hm-session-vars.sh";
      k = "kubectl";
      watch-log = ''watch -t --color "jj --no-pager --limit 20 --color=always"'';
      watch-st = ''watch -t --color "jj st --no-pager --color=always"'';
      ov = ''cd ~/Documents/"Obsidian Vault" && claude'';
    };
    enableCompletion = true;
    enableVteIntegration = pkgs.stdenv.isLinux;
    autocd = true;
    autosuggestion.enable = true;
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      ignoreSpace = true;
      path = "${config.xdg.dataHome}/zsh/history";
      save = 10000;
      share = true;
    };

    initContent = ''
      local ZVM_INIT_MODE=sourcing

      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

      source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-autopair.src}/zsh-autopair.plugin.zsh
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

      bindkey "''${terminfo[kcuu1]}" history-substring-search-up
      bindkey '^[[A' history-substring-search-up
      bindkey "''${terminfo[kcud1]}" history-substring-search-down
      bindkey '^[[B' history-substring-search-down

      ${pkgs.nix-your-shell}/bin/nix-your-shell --nom zsh | source /dev/stdin

      bindkey "''${terminfo[khome]}" beginning-of-line
      bindkey "''${terminfo[kend]}" end-of-line
      bindkey "''${terminfo[kdch1]}" delete-char
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;3C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;3D" backward-word
      bindkey -s "^O" 'fzf | xargs -r $EDITOR^M'
    '';
  };
}
