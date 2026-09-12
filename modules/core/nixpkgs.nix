{ config, ... }:

# Nixpkgs configuration for NixOS hosts

{
  nixpkgs.overlays = [
    config.my.inputs.spotxOverlay
  ];
}
