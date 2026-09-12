{ ... }:

{
  imports = [
    ./server-fail2ban.nix
    ./ssh-server.nix
    ./wireguard-server.nix
  ];
}
