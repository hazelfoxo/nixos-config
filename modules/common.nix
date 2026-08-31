{ inputs, pkgs, ... }:

{

  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops

    ./hardware
    ./desktop
    ./system
    ./networking
    ./gaming
    ./video-editing
  ];
}
