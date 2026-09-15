{ config, pkgs, ... }:

# Define Hazie's user account and configure home-manager for the user.

{
  # Define Hazie's user account.
  users.users.hazie = {
    isNormalUser = true;
    description = "Hazie";
    hashedPassword = "$y$j9T$erHrywcS5E69q9X6XoyqH1$7bcF58yYxXEzyCqJXVX.HUa3DgZ8huExTc8q1afZ2i5";

    # Set shell
    shell = pkgs.fish;

    # Set Groups
    extraGroups = [
      "wheel"
      "networkmanager"
      "kvm"
      "libvirtd"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      vscodeMarketplace = config.my.inputs.vscodeMarketplace;
    };

    users.hazie = {
      imports = [
        (import ../../home)
        config.my.inputs.plasmaManagerModule
      ];
    };
  };
}
