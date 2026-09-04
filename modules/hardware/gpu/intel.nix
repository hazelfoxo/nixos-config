{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf (config.my.hardware.gpu == "intel") {

  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
  };

  # Intel CPU thermal management
  services.thermald.enable = true;

  hardware.enableRedistributableFirmware = true;
}
