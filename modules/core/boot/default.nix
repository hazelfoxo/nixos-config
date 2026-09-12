{
  config,
  lib,
  ...
}:

# Bootloader configuration for NixOS hosts

{
  imports = [
    ./loader.nix
    ./systemd-boot.nix
    ./secureboot.nix
  ];

  config = lib.mkMerge [
    # Allow bootloaders to create UEFI entries on hosts that own one.
    (lib.mkIf (config.my.boot.loader != "none") {
      boot.loader.efi.canTouchEfiVariables = true;
    })

    # Desktop-focused boot cosmetics and loader behaviour.
    (lib.mkIf config.my.core.desktop.enable {
      boot.plymouth = {
        # Enable plymouth and set theme
        enable = true;
        theme = "bgrt";
      };

      # Set boot parameters for clean boot animation
      boot.kernelParams = [
        "quiet"
      ];

      # Supress boot messages
      boot.consoleLogLevel = 3;

      # Disable bootloader menu timeout
      boot.loader.timeout = 0;
    })
  ];
}
