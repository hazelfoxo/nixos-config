{
  lib,
  pkgs,
  inputs,
  ...
}:

# Inputs for NixOS hosts

{
  options.my.inputs = {
    spotxOverlay = lib.mkOption {
      type = lib.types.unspecified;
      readOnly = true;
      description = "SpotX overlay applied to nixpkgs.";
    };

    vscodeMarketplace = lib.mkOption {
      type = lib.types.unspecified;
      readOnly = true;
      description = "VSCode marketplace extension set from nix-vscode-extensions.";
    };

    plasmaManagerModule = lib.mkOption {
      type = lib.types.unspecified;
      readOnly = true;
      description = "plasma-manager home-manager module, installed under home-manager.users.";
    };

    sil6250Linux = lib.mkOption {
      type = lib.types.unspecified;
      readOnly = true;
      description = "sil6250 Linux kernel driver source.";
    };
  };

  config.my.inputs = {
    spotxOverlay = inputs.spotx-nix.overlays.default;

    vscodeMarketplace =
      inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace;

    plasmaManagerModule = inputs.plasma-manager.homeModules.plasma-manager;

    sil6250Linux = inputs.sil6250-linux;
  };
}
