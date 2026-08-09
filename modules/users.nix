{ pkgs, ... }:

{
  users.users.hazie = {
    isNormalUser = true;
    description = "Hazie";

    shell = pkgs.fish;

    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

}
