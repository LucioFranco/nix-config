{ pkgs, ... }: {
  programs.zsh = {
    enable = true;

    shellAliases = {
      b = "brazil";
      bb = "brazil-build";
      bbb = "brazil-build-recursive";
      http = "xh";
    };

#     initExtra = ''
#       # If there is a .venv folder (say created from poetry) in the folder that
#       # we just `cd` into then activate it, once we exit deactivate it.
#       # Ref: https://dev.to/moniquelive/auto-activate-and-deactivate-python-venv-using-zsh-4dlm
#       python_venv() {
#         MYVENV=.venv
#         # when you cd into a folder that contains $MYVENV
#         [[ -d $MYVENV ]] && source $MYVENV/bin/activate > /dev/null 2>&1
#         # when you cd into a folder that doesn't
#         [[ ! -d $MYVENV ]] && deactivate > /dev/null 2>&1
#       }
#       autoload -U add-zsh-hook
#       add-zsh-hook chpwd python_venv

#       python_venv
#     '';
  };
}
