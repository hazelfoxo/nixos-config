{ pkgs, ... }:

# Mprisence configuration for home-manager

{
  home.packages = [
    # Install mprisence
    pkgs.mprisence

    # Aliases for starting and stopping the mprisence service
    (pkgs.writeShellScriptBin "start-mprisence" ''
      systemctl --user start mprisence.service
    '')

    (pkgs.writeShellScriptBin "stop-mprisence" ''
      systemctl --user stop mprisence.service
    '')
  ];

  # Create a config to enable youtube detection
  home.file.".config/mprisence/config.toml".text = ''
    [web_player.youtube]
    ignore = false
    override_activity_type = "watching"
  '';

  # Create a systemd service for running mprisence in the background
  systemd.user.services.mprisence = {
    Unit = {
      Description = "MPRISence Discord Rich Presence";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.mprisence}/bin/mprisence";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
