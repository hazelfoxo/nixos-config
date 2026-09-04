{ ... }:

{
  # Client networking bundle used by workstation hosts. Wi-Fi and OpenVPN
  # are NOT part of the bundle: they are owned by the profiles that consume
  # them (my.profiles.sharedNetworking) so each module is imported exactly
  # once per host.
  imports = [
    ./networking.nix
    ./tailscale.nix
    ./wireguard.nix
    ./ssh.nix
    ./proton-vpn.nix
  ];
}
