{ config, lib, ... }:

# Host configuration options for NixOS hosts

{
  options.my.host = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "Identifier used to build, switch, and target this host.";
    };

    hostName = lib.mkOption {
      type = lib.types.str;
      description = "Machine hostname.";
    };

    sopsFile = lib.mkOption {
      type = lib.types.path;
      description = "SOPS file holding this host's secrets.";
    };
  };

  config = {
    networking.hostName = lib.mkDefault config.my.host.hostName;

    environment.variables.NIXOS_HOST = lib.mkDefault config.my.host.name;

    sops.defaultSopsFile = config.my.host.sopsFile;
  };
}
