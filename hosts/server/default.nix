{ host, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./access.nix
    ./host-key.nix
    ./wifi.nix
    ./wireguard.nix

    ../../modules/profiles/server.nix
  ];

  networking.hostName = host.hostName;
  environment.variables.NIXOS_HOST = host.name;

  sops = {
    defaultSopsFile = ../../secrets/hosts/server.yaml;
    age.keyFile = "/var/lib/sops-nix/device-key.txt";
  };

  my.server.firewall.enable = true;

  # Enable after the SOPS device key and encrypted SSH host key are restored.
  my.server.hostKey.enable = false;
}
