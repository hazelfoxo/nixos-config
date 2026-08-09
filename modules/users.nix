{ pkgs, ... }:

{
  # Define default user account
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

}
