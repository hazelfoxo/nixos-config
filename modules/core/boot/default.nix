{ ... }:

{
  # Allow bootloader to create UEFI entries
  boot.loader = {
    efi.canTouchEfiVariables = true;
  };

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
}
