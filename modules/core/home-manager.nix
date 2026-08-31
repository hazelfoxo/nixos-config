{ inputs, ... }:

{
  home-manager = {

    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs;
    };

    users.hazie = import ../../home/home.nix;

  };
}
