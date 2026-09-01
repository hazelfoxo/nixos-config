{ ... }:

{
  # Enable Network Manager Service
  networking.networkmanager.enable = true;

  # Make the nm-file-secret-agent run in user mode
  systemd.services.nm-file-secret-agent.serviceConfig = {
    User = "hazie";
    Group = "users";
  };
}
