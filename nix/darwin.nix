{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs; [
      neovim
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
