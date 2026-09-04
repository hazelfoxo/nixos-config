{ lib, ... }:

{
  options.my.boot.loader = lib.mkOption {
    type = lib.types.enum [
      "none"
      "systemd-boot"
      "secureboot"
    ];
    default = "none";
    description = ''
      Boot strategy used by this host.

      - "systemd-boot" uses sysemd-boot directly.
      - "secureboot" enables Lanzaboote and requires an sbctl bundle.
    '';
  };
}
