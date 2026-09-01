  { inputs, ... }:

  {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops

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
