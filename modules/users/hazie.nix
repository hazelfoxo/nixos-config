{ inputs, pkgs, ... }:

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
    };

    users.hazie = import ../../home;
  };
}
