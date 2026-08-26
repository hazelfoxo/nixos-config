{  ... }:
{
    programs.thunderbird = {
    enable = true;

    profiles.default = {
        isDefault = true;

        settings = {
            "mailnews.start_page.enabled" = false;
        };
    };
    };
}
