{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./VPN
    
    ../../modules/hardware/intel.nix
    ../../modules/system/systemd-boot.nix
  ];

  sops.defaultSopsFile = ../../secrets/hosts/laptop.yaml;

  networking.hostName = "hazie-laptop";

  environment.variables.NIXOS_HOST = "laptop";
}
