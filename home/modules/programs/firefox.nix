{ pkgs, ... }:

{
    programs.firefox = {
    enable = true;

    nativeMessagingHosts = [
        pkgs.kdePackages.plasma-browser-integration
    ];

    profiles.default = {
        settings = {
            # ─────────────────────────────────────────────
            # New Tab / Nova
            # ─────────────────────────────────────────────
            "browser.newtabpage.activity-stream.widgets.enabled" = true;
            "browser.newtabpage.activity-stream.widgets.system.enabled" = true;
            "browser.newtabpage.activity-stream.nova.enabled" = true;

            # ─────────────────────────────────────────────
            # New Tab widgets
            # ─────────────────────────────────────────────
            "browser.newtabpage.activity-stream.widgets.clocks.enabled" = false;
            "browser.newtabpage.activity-stream.widgets.crossword.enabled" = true;
            "browser.newtabpage.activity-stream.widgets.focusTimer.enabled" = true;
            "browser.newtabpage.activity-stream.widgets.lists.enabled" = true;
            "browser.newtabpage.activity-stream.widgets.pictureOfTheDay.enabled" = true;
            "browser.newtabpage.activity-stream.widgets.privacy.enabled" = false;
            "browser.newtabpage.activity-stream.widgets.recentSearches.enabled" = true;
            "browser.newtabpage.activity-stream.widgets.sportsWidget.enabled" = false;
            "browser.newtabpage.activity-stream.widgets.stocks.enabled" = false;

            # System widget availability
            "browser.newtabpage.activity-stream.widgets.system.clocks.enabled" = true;
            "browser.newtabpage.activity-stream.widgets.system.crossword.enabled" = true;
            "browser.newtabpage.activity-stream.widgets.system.focusTimer.enabled" = true;
            "browser.newtabpage.activity-stream.widgets.system.lists.enabled" = true;
            "browser.newtabpage.activity-stream.widgets.system.pictureOfTheDay.enabled" = true;
            "browser.newtabpage.activity-stream.widgets.system.privacy.enabled" = true;
            "browser.newtabpage.activity-stream.widgets.system.sportsWidget.enabled" = true;
            "browser.newtabpage.activity-stream.widgets.system.stocks.enabled" = true;
            "browser.newtabpage.activity-stream.widgets.system.weatherForecast.enabled" = true;

            # ─────────────────────────────────────────────
            # Widget interactions
            # ─────────────────────────────────────────────
            "browser.newtabpage.activity-stream.widgets.focusTimer.interaction" = true;
            "browser.newtabpage.activity-stream.widgets.lists.interaction" = true;
            "browser.newtabpage.activity-stream.widgets.pictureOfTheDay.interaction" = true;
            "browser.newtabpage.activity-stream.widgets.sportsWidget.interaction" = true;
            "browser.newtabpage.activity-stream.widgets.weatherForecast.interaction" = true;

            # Focus Timer extras
            "browser.newtabpage.activity-stream.widgets.focusTimer.showSystemNotifications" = true;

            # Sports
            "browser.newtabpage.activity-stream.widgets.sports.forceLiveDataTrustable" = true;
            "browser.newtabpage.activity-stream.widgets.sportsWidget.celebrations.enabled" = true;
            "browser.newtabpage.activity-stream.widgets.sportsWidget.live.enabled" = true;

            # Weather
            "browser.newtabpage.activity-stream.widgets.weather.size" = "large";

            # Lists
            "browser.newtabpage.activity-stream.widgets.lists.badge.enabled" = true;

            # Picture of the Day
            "browser.newtabpage.activity-stream.widgets.pictureOfTheDay.setAsWallpaper.enabled" = true;

            # ─────────────────────────────────────────────
            # Widget layout
            # ─────────────────────────────────────────────
            "browser.newtabpage.activity-stream.widgets.maximized" = true;
            "browser.newtabpage.activity-stream.widgets.row.expanded" = true;
            "browser.newtabpage.activity-stream.widgets.hideAllToast.enabled" = true;
            "browser.newtabpage.activity-stream.widgets.crossword.interaction" = true;
            "browser.newtabpage.activity-stream.widgets.crossword.size" = "large";
            "browser.newtabpage.activity-stream.widgets.order" =
            "pictureOfTheDay,sportsWidget,clocks,weather,focusTimer,lists,privacy,crossword,stocks";
            "browser.newtabpage.activity-stream.widgets.pictureOfTheDay.size" = "large";


            # ─────────────────────────────────────────────
            # New Tab content
            # ─────────────────────────────────────────────

            # Disable Recommended by Pocket / sponsored stories
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;

            # Disable sponsored stories
            "browser.newtabpage.activity-stream.showSponsored" = false;

            # Disable sponsored content on the New Tab page
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

            # Other New Tab sections
            "browser.newtabpage.activity-stream.feeds.topsites" = true;
            "browser.newtabpage.activity-stream.feeds.section.highlights" = true;
            "browser.newtabpage.activity-stream.showSearch" = true;
            };

        };
    };
}
