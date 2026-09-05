{ ... }:

{
  # Low-level network module definitions, each gated on its own option.
  # This bundle is imported once by the profiles layer; profiles and hosts
  # only set options, they never import these directly.
  imports = [
    ./networking.nix
    ./wifi.nix
    ./wireguard.nix
    ./openvpn.nix
    ./ssh.nix
  ];
}
