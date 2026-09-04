{ lib, ... }:

{
  options.my.hardware.gpu = lib.mkOption {
    type = lib.types.enum [
      "none"
      "nvidia"
      "intel"
    ];
    default = "none";
    description = "GPU platform used to load the matching driver configuration.";
  };

  imports = [
    ./nvidia.nix
    ./intel.nix
  ];
}
