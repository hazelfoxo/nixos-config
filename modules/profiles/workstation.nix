{ inputs, pkgs, ... }:

{

  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops

    ../hardware
    ../features/desktop
    ../networking
    ../features/gaming
    ../features/video-editing
  ];
}
