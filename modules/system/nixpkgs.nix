{ inputs, pkgs, ... }:

{
  nixpkgs = {

    overlays = [
      inputs.spotx-nix.overlays.default
    ];

    config.allowUnfreePredicate = pkg:
      builtins.elem (pkgs.lib.getName pkg) [
        "spotify"
        "spotify-spotx"
      ];

  };
}
