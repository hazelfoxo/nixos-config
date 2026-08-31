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
      ./users.nix
      ./boot
      ./secrets.nix
      ./home-manager.nix
      ./nixpkgs.nix
    ];
  }
