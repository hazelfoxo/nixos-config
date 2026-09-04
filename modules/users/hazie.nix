{ config, inputs, pkgs, ... }:

{
  # Define Hazie's user account.
  users.users.hazie = {
    isNormalUser = true;
    description = "Hazie";

    # Set shell
    shell = pkgs.fish;

    # Set Groups
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs;

      kde = {
        enable = config.my.features.desktop.kde.enable;
        wallpaper = config.my.profiles.workstation.desktop.kde.wallpaper;
      };
    };

    users.hazie = import ../../home;
  };
}
