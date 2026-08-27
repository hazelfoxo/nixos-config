{ config, lib, ... }:

let
  cfg = config.my.wireguard;

  privateKeyEnv = config.sops.templates.wireguard-private-key-env.path;
in
{
  options.my.wireguard = {
    enable = lib.mkEnableOption "WireGuard VPN managed by NetworkManager";

    connectionName = lib.mkOption {
      type = lib.types.str;
      default = "wg0";
    };

    interface = lib.mkOption {
      type = lib.types.str;
      default = "wg0";
    };

    address = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    serverPublicKey = lib.mkOption {
      type = lib.types.str;
    };

    endpoint = lib.mkOption {
      type = lib.types.str;
    };

    allowedIPs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    persistentKeepalive = lib.mkOption {
      type = lib.types.int;
      default = 25;
    };
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    sops.secrets.wireguard_private_key = {
      mode = "0400";
    };

    sops.templates.wireguard-private-key-env = {
      mode = "0400";
      content = ''
        WIREGUARD_PRIVATE_KEY=${config.sops.placeholder.wireguard_private_key}
      '';
    };

    networking.networkmanager.ensureProfiles = {
      environmentFiles = [
        privateKeyEnv
      ];

      profiles = {
        "${cfg.connectionName}" = {
          connection = {
            id = cfg.connectionName;
            type = "wireguard";
            interface-name = cfg.interface;
            autoconnect = false;
          };

          wireguard = {
            private-key = "$WIREGUARD_PRIVATE_KEY";
            private-key-flags = 0;
          };

          "wireguard-peer.${cfg.serverPublicKey}" = {
            public-key = cfg.serverPublicKey;
            endpoint = cfg.endpoint;
            allowed-ips =
              lib.concatStringsSep ";" cfg.allowedIPs;
            persistent-keepalive =
              cfg.persistentKeepalive;
          };

          ipv4 = {
            method = "manual";
            addresses =
              lib.concatStringsSep ";" cfg.address;
          };

          ipv6 = {
            method = "ignore";
          };
        };
      };
    };
  };
}