{ config, lib, ... }:

# Systemd-boot configuration for NixOS hosts

lib.mkIf (config.my.boot.loader == "systemd-boot") {
  boot.loader = {
    systemd-boot.enable = true;
  };
}
