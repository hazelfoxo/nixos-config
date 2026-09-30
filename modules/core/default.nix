{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  options.my.core.desktop.enable = lib.mkEnableOption "desktop-oriented system services";

  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    inputs.lanzaboote.nixosModules.lanzaboote

    ./host.nix
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

  config = {
    _module.args = {
      spotxOverlay = inputs.spotx-nix.overlays.default;

      vscodeMarketplace =
        inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace;

      plasmaManagerModule = inputs.plasma-manager.homeModules.plasma-manager;

      sil6250Linux = inputs.sil6250-linux;
    };
  };
}
