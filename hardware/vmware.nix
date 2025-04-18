{ pkgs, config, ... }: {
  services.openssh.enable = true;

  virtualisation.vmware.guest.enable = true;

  networking.hostName = "nixos-vm";
  networking.useDHCP = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # VMware, Parallels both only support this being 0 otherwise you see
  # "error switching console mode" on boot.
  boot.loader.systemd-boot.consoleMode = "0";
}
