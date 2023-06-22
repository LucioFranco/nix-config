{ ... }: {
  # boot.growPartition = true;
  # boot.loader.grub.device = "/dev/sda";

  # swapDevices = [{
  #   device = "/var/swap";
  #   size = 2048;
  # }];

  # fileSystems = {
  #   "/" = {
  #     device = "/dev/disk/by-label/nixos";
  #     autoResize = true;
  #     fsType = "ext4";
  #   };
  # };

  # virtualisation.virtualbox.guest.enable = true;

  # boot.loader.grub.fsIdentifier = "provided";
}
