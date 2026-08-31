  { pkgs, ... }:

  {
  # Enable Steam
  programs.steam = {
    enable = true;
    extraPackages = with pkgs; [
      kdePackages.breeze
    ];
  };
}
