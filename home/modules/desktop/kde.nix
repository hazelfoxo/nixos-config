{ osConfig, ... }:

{
  programs.plasma = {
    enable = osConfig.my.features.desktop.kde.enable;

    workspace.wallpaper = osConfig.my.features.desktop.kde.wallpaper;

    configFile = {
      kdeglobals.General = {
        accentColorFromWallpaper = true;
        fixed = "CaskaydiaCove Nerd Font,10,...";
        XftAntialias = true;
        XftHintStyle = "hintslight";
        XftSubPixel = "rgb";
      };
      katerc."KTextEditor Renderer"."Text Font" = "CaskaydiaCove Nerd Font,...";
      kwinrc.Plugins.magiclampEnabled = true;
      kwinrc.Plugins.squashEnabled = false;
      kwinrc.Plugins.blurEnabled = true;
      kwinrc.Wayland.EnablePrimarySelection = false;
      spectaclerc.General.clipboardGroup = "PostScreenshotCopyImage";
      spectaclerc.ImageSave.translatedScreenshotsFolder = "Screenshots";
      spectaclerc.VideoSave.translatedScreencastsFolder = "Screencasts";
      kiorc.Confirmations.ConfirmDelete = true;
      kiorc.Confirmations.ConfirmEmptyTrash = true;
    };
    shortcuts = {
      krunnerrc.Plugins.baloosearchEnabled = false;
      krunnerrc.Plugins.browserhistoryEnabled = false;
      krunnerrc.Plugins.browsertabsEnabled = false;
      krunnerrc.Plugins.helprunnerEnabled = false;
      krunnerrc.Plugins.krunner_appstreamEnabled = false;
      krunnerrc.Plugins.krunner_bookmarksrunnerEnabled = false;
      krunnerrc.Plugins.krunner_charrunnerEnabled = false;
      krunnerrc.Plugins.krunner_katesessionsEnabled = false;
      krunnerrc.Plugins.krunner_konsoleprofilesEnabled = false;
      krunnerrc.Plugins.krunner_placesrunnerEnabled = false;
      krunnerrc.Plugins.krunner_recentdocumentsEnabled = false;
      krunnerrc.Plugins.krunner_sessionsEnabled = false;
      krunnerrc.Plugins.krunner_spellcheckEnabled = true;
      krunnerrc.Plugins.krunner_webshortcutsEnabled = false;
      krunnerrc.Plugins.locationsEnabled = false;
      krunnerrc.Plugins."org.kde.activities2Enabled" = false;
      krunnerrc.Plugins."org.kde.datetimeEnabled" = false;
      krunnerrc.Plugins.unitconverterEnabled = true;
      krunnerrc.Plugins.windowsEnabled = false;
      krunnerrc."Plugins/Favorites".plugins = "krunner_sessions,krunner_powerdevil,krunner_services,krunner_systemsettings";
    };
  };
}
