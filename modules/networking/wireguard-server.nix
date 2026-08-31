{ config, lib, ... }:

let
  cfg = config.my.server.wireguard;
in
{
  options.my.server.wireguard = {
    enable = lib.mkEnableOption "a WireGuard server";

    interface = lib.mkOption {
      type = lib.types.str;
      default = "wg0";
    };

    address = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    listenPort = lib.mkOption {
      type = lib.types.port;
      default = 51820;
    };

    privateKeySecret = lib.mkOption {
      type = lib.types.str;
      default = "wireguard-server-private-key";
    };

    peers = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          publicKey = lib.mkOption { type = lib.types.str; };
          allowedIPs = lib.mkOption {
            type = lib.types.listOf lib.types.str;
          };
        };
      });
      default = { };
    };

    enableForwarding = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.${cfg.privateKeySecret} = {
      owner = "root";
      group = "root";
      mode = "0400";
    };

    networking.wg-quick.interfaces.${cfg.interface} = {
      inherit (cfg) address listenPort;
      privateKeyFile = config.sops.secrets.${cfg.privateKeySecret}.path;
      peers = lib.mapAttrsToList (_: peer: {
        inherit (peer) publicKey allowedIPs;
      }) cfg.peers;
    };

    boot.kernel.sysctl = lib.mkIf cfg.enableForwarding {
      "net.ipv4.ip_forward" = 1;
    };
  };
}
