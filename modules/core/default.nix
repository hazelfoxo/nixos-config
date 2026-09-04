{ inputs, lib, ... }:

{
  options.my.core.desktop.enable = lib.mkEnableOption "desktop-oriented system services";

  # Flake extensions installed at the boundary. Module `imports` cannot
  # reference options, so these must be loaded here; everything else in the
  # tree consumes their flake-provided pieces through the `my.inputs` option.
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    inputs.lanzaboote.nixosModules.lanzaboote

    ./host.nix
    ./inputs.nix
    ./locale.nix
    ./system.nix
    ./nix.nix
    ./packages.nix
    ./fonts.nix
    ./programs.nix
    ./security.nix
    ./boot
    ./secrets.nix
    ./shared-secrets.nix
    ./nixpkgs.nix
  ];
}
