{ pkgs, inputs, outputs, config, ... }: {
  imports = [ ./nixos.nix ];

  wsl = {
    enable = true;
    defaultUser = "lucio";
  };
}
