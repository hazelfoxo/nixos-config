{ host, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./vpn
  ];
  
  sops.defaultSopsFile = host.sopsFile;

  networking.hostName = host.hostName;

  environment.variables.NIXOS_HOST = host.name;
}
