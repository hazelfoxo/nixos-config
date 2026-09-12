{ config, lib, ... }:

let
  cfg = config.my.wireguard;

in
{
  options.my.wireguard = {
    enable = lib.mkEnableOption "WireGuard VPN profiles managed by NetworkManager";

    profiles = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            privateKeySecret = lib.mkOption {
              type = lib.types.str;
              description = "Name of the SOPS secret containing this profile's WireGuard private key.";
            };

            interface = lib.mkOption {
              type = lib.types.str;
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

            neverDefault = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Only route traffic to the WireGuard subnet through the tunnel.";
            };
          };
        }
      );

      default = { };
    };

  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    sops.secrets = lib.mapAttrs' (
      _: profile:
      lib.nameValuePair profile.privateKeySecret {
        mode = "0400";
      }
    ) cfg.profiles;

    sops.templates = lib.mapAttrs' (
      connectionName: profile:
      lib.nameValuePair "wireguard-${connectionName}-private-key-env" {
        mode = "0400";

        content = ''
          WIREGUARD_PRIVATE_KEY=${config.sops.placeholder.${profile.privateKeySecret}}
        '';
      }
    ) cfg.profiles;

    networking.networkmanager.ensureProfiles = {
      environmentFiles = lib.mapAttrsToList (
        connectionName: _: config.sops.templates."wireguard-${connectionName}-private-key-env".path
      ) cfg.profiles;

      profiles = lib.mapAttrs (connectionName: profile: {
        connection = {
          id = connectionName;
          type = "wireguard";
          interface-name = profile.interface;
          autoconnect = false;
        };

        wireguard = {
          private-key = "$WIREGUARD_PRIVATE_KEY";
          private-key-flags = 0;
        };

        "wireguard-peer.${profile.serverPublicKey}" = {
          public-key = profile.serverPublicKey;
          endpoint = profile.endpoint;

          allowed-ips = lib.concatStringsSep ";" profile.allowedIPs;

          persistent-keepalive = profile.persistentKeepalive;
        };

        ipv4 = {
          method = "manual";

          never-default = profile.neverDefault;

          addresses = lib.concatStringsSep ";" profile.address;
        };

        ipv6 = {
          method = "ignore";
        };
      }) cfg.profiles;
    };

  };
}
