{ ... }:

# Server-only modules for NixOS hosts

{
  imports = [
    ./fail2ban.nix
    ./firewall.nix
    ./host-key.nix
    ./ssh.nix
    ./wireguard.nix
  ];
}
