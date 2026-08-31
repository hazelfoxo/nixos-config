{ ... }:

{
  imports = [
    ../core/locale.nix
    ../core/nix.nix
  ];

  # Keep this profile independent from the desktop-oriented core module.
  system.stateVersion = "26.05";
}
