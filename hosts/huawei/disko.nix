{ ... }:

# Disk layout configuration for the laptop host

{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b444a41db09fd";

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
            size = "24G";

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
