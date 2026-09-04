{ config, lib, ... }:

lib.mkIf (config.my.boot.loader == "systemd-boot") {
  boot.loader = {
    systemd-boot.enable = true;
  };
}
