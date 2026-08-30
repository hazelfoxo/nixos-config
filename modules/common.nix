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

  home-manager = {

    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs;
    };

    users.hazie = import ../home/home.nix;

  };
}
