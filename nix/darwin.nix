{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      vscode
      rustup
      python38
      protobuf
      iterm2
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
      git
      gnugrep
      gnused
      gnutar
      gnutls

      neovim
      starship
      zsh

      rust-analyzer
      tmux

      fzf
      ripgrep
      fd
    ];

  users.users.luciofra = {
    name = "luciofra";
    home = "/Users/luciofra";
  };

  # fonts = {
  #   fontDir.enable = true;
  #   fonts = with pkgs; [ (nerdfonts.override { fonts = [ "Hack" ]; }) ];
  # };

  programs.zsh.enable = true;

  imports = [
    ../home
  ];

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
}
