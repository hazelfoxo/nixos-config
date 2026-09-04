{ config, ... }:

{
  nixpkgs.overlays = [
    config.my.inputs.spotxOverlay
  ];
}
