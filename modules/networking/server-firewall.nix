{ config, lib, ... }:

let
  cfg = config.my.server.firewall;
  wireguard = config.my.server.wireguard;
  ssh = config.my.server.ssh;
in {
  options.my.server.firewall.enable = lib.mkEnableOption "the server's VPN-first firewall";

  config = lib.mkIf cfg.enable {
    networking.nftables.enable = true;
    networking.firewall = {
      enable = true;
      logRefusedConnections = true;
    } // lib.optionalAttrs wireguard.enable {
      interfaces.${wireguard.interface}.allowedTCPPorts = lib.optional ssh.enable ssh.port;
      extraInputRules = ''
        ct state new udp dport ${toString wireguard.listenPort} meter wireguard_handshakes {
          ip saddr limit rate 12/minute burst 6 packets
        } accept
      '';
    };
  };
}
