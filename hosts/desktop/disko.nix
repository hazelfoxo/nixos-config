{ ... }:

# Disk layout configuration for the laptop host

{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/ata-KINGSTON_SA400S37240G_50026B7782AE9930";

      content = {
        type = "gpt";

        partitions = {

          # ESP Partition
          ESP = {
            size = "1G";
            type = "EF00";

            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          # Swap Partition

          swap = {
            size = "35G";

            content = {
              type = "swap";
              randomEncryption = false;
            };
          };

          # Root Partition

          root = {
            size = "100%";

            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              extraArgs = [
                "-L"
                "NixOS"
              ];
            };
          };
        };
      };
    };
  };
}
