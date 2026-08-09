{ ... }:

{
  # Overlay for spotify -adblock
  # https://github.com/abba23/spotify-adblock
  nixpkgs.overlays = [
    (final: prev: {
      spotify-adblock = final.callPackage ../packages/spotify-adblock.nix {};
    })
  ];
}
