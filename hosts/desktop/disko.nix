{ ... }:

{
  # Add this file to hosts/desktop/default.nix imports after defining the
  # desktop disk device and partition layout. It is intentionally unimported
  # until then, so the placeholder cannot affect the desktop system.
  disko.devices = { };
}
