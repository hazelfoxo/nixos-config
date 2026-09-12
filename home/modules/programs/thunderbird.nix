{ ... }:

# Enable Thunderbird and configure its settings

{
  programs.thunderbird = {
    enable = true;

    profiles.default = {
      isDefault = true;

      # Confgure Thunderbird settings
      settings = {
        "mailnews.start_page.enabled" = false; # Disable default start page
      };
    };
  };
}
