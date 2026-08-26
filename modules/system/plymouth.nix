{ ... }:

{
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };

  boot.kernelParams = [
    "quiet"
    "splash"
  ];
}
