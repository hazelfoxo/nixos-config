{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf (config.my.boot.loader == "secureboot") {
    environment.systemPackages = [
      pkgs.sbctl
    ];

    # Lanzaboote is hosted by ./default.nix (the flake boundary).
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
