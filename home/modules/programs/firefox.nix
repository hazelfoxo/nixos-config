{ osConfig, pkgs, ... }:

{
    programs.firefox = {
        enable = true;

        nativeMessagingHosts = [
            pkgs.kdePackages.plasma-browser-integration
        ];

        profiles.default = {
            settings = {
                # ─────────────────────────────────────────────
                # General
                # ─────────────────────────────────────────────

                # Firefox Sync device name
                "identity.fxaccounts.account.device.name" =
                osConfig.networking.hostName;

                # Disable middle-click paste
                "middlemouse.paste" = false;


                # ─────────────────────────────────────────────
                # New Tab
                # ─────────────────────────────────────────────

                # Nova / widget system
                "browser.newtabpage.activity-stream.widgets.enabled" = true;
                "browser.newtabpage.activity-stream.widgets.system.enabled" = true;
                "browser.newtabpage.activity-stream.nova.enabled" = true;


                # ─────────────────────────────────────────────
                # New Tab — Content
                # ─────────────────────────────────────────────

                # Search and sites
                "browser.newtabpage.activity-stream.showSearch" = true;
                "browser.newtabpage.activity-stream.feeds.topsites" = true;
                "browser.newtabpage.activity-stream.feeds.section.highlights" = true;

                # Disable Pocket / recommended stories
                "browser.newtabpage.activity-stream.feeds.section.topstories" = false;

                # Disable sponsored content
                "browser.newtabpage.activity-stream.showSponsored" = false;
                "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;


                # ─────────────────────────────────────────────
                # New Tab — Widgets
                # ─────────────────────────────────────────────

                # Widget availability
                "browser.newtabpage.activity-stream.widgets.clocks.enabled" = false;
                "browser.newtabpage.activity-stream.widgets.crossword.enabled" = true;
                "browser.newtabpage.activity-stream.widgets.focusTimer.enabled" = true;
                "browser.newtabpage.activity-stream.widgets.lists.enabled" = true;
                "browser.newtabpage.activity-stream.widgets.pictureOfTheDay.enabled" = true;
                "browser.newtabpage.activity-stream.widgets.privacy.enabled" = false;
                "browser.newtabpage.activity-stream.widgets.recentSearches.enabled" = true;
                "browser.newtabpage.activity-stream.widgets.sportsWidget.enabled" = false;
                "browser.newtabpage.activity-stream.widgets.stocks.enabled" = false;


                # ─────────────────────────────────────────────
                # New Tab — System Widgets
                # ─────────────────────────────────────────────

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
                # New Tab — Widget Interactions
                # ─────────────────────────────────────────────

                "browser.newtabpage.activity-stream.widgets.focusTimer.interaction" = true;
                "browser.newtabpage.activity-stream.widgets.lists.interaction" = true;
                "browser.newtabpage.activity-stream.widgets.pictureOfTheDay.interaction" = true;
                "browser.newtabpage.activity-stream.widgets.sportsWidget.interaction" = true;
                "browser.newtabpage.activity-stream.widgets.weatherForecast.interaction" = true;
                "browser.newtabpage.activity-stream.widgets.crossword.interaction" = true;


                # ─────────────────────────────────────────────
                # New Tab — Widget Settings
                # ─────────────────────────────────────────────

                # Focus Timer
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
                # New Tab — Layout
                # ─────────────────────────────────────────────

                "browser.newtabpage.activity-stream.widgets.maximized" = true;
                "browser.newtabpage.activity-stream.widgets.row\\.expanded" = true;
                "browser.newtabpage.activity-stream.widgets.hideAllToast.enabled" = true;

                "browser.newtabpage.activity-stream.widgets.order" =
                "pictureOfTheDay,sportsWidget,clocks,weather,focusTimer,lists,privacy,crossword,stocks";

                "browser.newtabpage.activity-stream.widgets.pictureOfTheDay.size" = "large";
                "browser.newtabpage.activity-stream.widgets.crossword.size" = "large";
            };

        };
    };
}
