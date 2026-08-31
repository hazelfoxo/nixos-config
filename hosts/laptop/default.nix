{ host, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./vpn
  ];

  sops.defaultSopsFile = host.sopsFile;

  networking.hostName = host.hostName;

  environment.variables.NIXOS_HOST = host.name;

  my.profiles.workstation = {
    enable = true;
    desktop.enable = true;
    gaming.enable = true;
    videoEditing.enable = true;
    tailscale.enable = true;
    protonVpn.enable = true;
  };
}
