{ ... }:

{
  # Declarative replacement for the supplied UFW policy. NixOS manages these
  # rules directly; do not enable UFW alongside this firewall.
  networking.firewall = {
    enable = true;
    logRefusedConnections = true;

    # WireGuard is the only public service.
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];

    # SSH is reachable only after connecting to WireGuard.
    interfaces.wg0.allowedTCPPorts = [
      2222 # SSH
    ];

    # Equivalent to UFW's per-source UDP 51820 limit. The average is twelve
    # new handshakes per minute, with a burst of six (six per 30 seconds).
    extraInputRules = ''
      ct state new udp dport 51820 meter wireguard_handshakes {
        ip saddr limit rate 12/minute burst 6 packets
      } accept
    '';
  };

  networking.nftables.enable = true;
}
