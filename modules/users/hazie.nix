{
  pkgs,
  plasmaManagerModule,
  vscodeMarketplace,
  ...
}:

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

  # The NetworkManager file secret agent must run as the user that owns
  # per-user secrets; most hosts that need VPN/Wi-Fi secrets have this user.
  my.secrets.secretsUser = "hazie";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      vscodeMarketplace = vscodeMarketplace;
    };

    users.hazie = {
      imports = [
        (import ../../home)
        plasmaManagerModule
      ];
    };
  };
}
