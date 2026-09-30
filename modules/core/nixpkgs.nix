{ spotxOverlay, ... }:

# Nixpkgs configuration for NixOS hosts

{
  nixpkgs.overlays = [ spotxOverlay ];
}
