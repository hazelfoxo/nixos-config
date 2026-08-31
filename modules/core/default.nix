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
      ./boot
      ./secrets.nix
      ./nixpkgs.nix
    ];
  }
