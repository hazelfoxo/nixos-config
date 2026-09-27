{
  pkgs,
  lib,
  osConfig,
  ...
}:

# Tailscale system tray entry for hosts with the Tailscale profile enabled

{
  config = lib.mkIf osConfig.my.profiles.tailscale.enable {
    xdg.desktopEntries.tailscale-systray = {
      name = "Tailscale";
      comment = "Tailscale system tray";
      exec = "${pkgs.tailscale}/bin/tailscale systray";
      icon = "tailscale";
      terminal = false;
      categories = [ "Network" ];
    };
  };
}
