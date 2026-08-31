{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./vpn
    ../../modules/profiles/workstation.nix
    
    ../../modules/hardware/gpu/intel.nix
    ../../modules/core/boot/systemd-boot.nix
  ];

  sops.defaultSopsFile = ../../secrets/hosts/laptop.yaml;

  networking.hostName = "hazie-laptop";

  environment.variables.NIXOS_HOST = "laptop";
}
