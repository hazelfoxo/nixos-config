{ ... }:

{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/";

      content = {
        type = "gpt";

        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";

            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "fmask=0077"
                "dmask=0077"
              ];
            };
          };

          swap = {
            size = "16.9G";

            content = {
              type = "swap";
              randomEncryption = false;
            };
          };

          root = {
            size = "100%";

            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
