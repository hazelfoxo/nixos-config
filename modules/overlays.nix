{ ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      spotify-adblock = final.callPackage ../packages/spotify-adblock.nix {};
    })
  ];
}
