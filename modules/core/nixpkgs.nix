{ inputs, ... }:

{
  nixpkgs.overlays = [
    inputs.spotx-nix.overlays.default
  ];
}
