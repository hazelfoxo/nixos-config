{ config, lib, ... }:

{
  config = lib.mkMerge [

    {
      system.stateVersion = "26.05";
    }

    (lib.mkIf config.my.core.desktop.enable {

      # Enable Polkit Service
      security.polkit = {
        enable = true;
        enablePkexecWrapper = true;
      };

    })

  ];
}
