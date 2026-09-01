{ config, pkgs, ... }:

{
  # Enable Firefox
  programs.firefox = {
    enable = true;

    autoConfig = ''
      pref(
        "identity.fxaccounts.account.device.name",
        "${config.networking.hostName}"
      );
    '';
  };

  # Enable Fish
  programs.fish.enable = true;

  programs.localsend.enable = true;
}
