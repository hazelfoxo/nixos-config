{
  config,
  lib,
  pkgs,
  ...
}:

# DDC/CI control of external monitors (brightness/contrast without a KVM).

let
  cfg = config.my.hardware.ddc;

  defaultI2cModules =
    {
      none = [ ];
      intel = [ "i2c-i915" ];
      nvidia = [ ];
    }
    .${config.my.hardware.gpu};
in
{
  options.my.hardware.ddc = {
    enable = lib.mkEnableOption "DDC/CI monitor control via ddcutil";

    i2cModules = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = defaultI2cModules;
      description = ''
        Kernel modules providing the GPU's DDC/CI i2c adapter. Defaults to the
        driver matching my.hardware.gpu.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.i2c.enable = true;

    boot.kernelModules = cfg.i2cModules;

    environment.systemPackages = [ pkgs.ddcutil ];
  };
}
