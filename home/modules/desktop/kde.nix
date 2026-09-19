{ osConfig, ... }:

# Kde Plasma desktop configuration module for NixOS home-manager

{
  programs.plasma = {
    enable = osConfig.my.profiles.desktop.kde.enable;

    # Set the wallpaper for both the workspace and the lock screen to the same image
    workspace.wallpaper = osConfig.my.profiles.desktop.kde.wallpaper;
    kscreenlocker.appearance.wallpaper = osConfig.my.profiles.desktop.kde.wallpaper;

    # Input Devices configuration
    input = {
      touchpads = [
        # Dell Touchpad
        {
          name = "DLL09D9:00 04F3:3146 Touchpad";
          vendorId = "04f3";
          productId = "3146";
          enable = true;
          naturalScroll = true;
        }
      ];

      mice = [
        # Glorius Model O Eternal
        {
          name = "SINOWEALTH Model O Eternal";
          vendorId = "3794";
          productId = "a000";
          enable = true;
          acceleration = 0;
          accelerationProfile = "none";
        }
	
        # Logitech M196
        {
          name = "Logi M196 Mouse";
          vendorId = "046d";
          productId = "b03f";
          enable = true;
          acceleration = 0;
          accelerationProfile = "none";
        }
      ];
    };

    # Appearance configuration
    configFile = {

      gwenviewrc = {
        SideBar = {
          PreferredMetaInfoKeyList =
            "General.Name,General.Size,General.Created,General.ImageSize,General.MimeType";
        };
      };

      kdeglobals.General = {
        accentColorFromWallpaper = true;
        fixed = "CaskaydiaCove Nerd Font,10,...";
        XftAntialias = true;
        XftHintStyle = "hintslight";
        XftSubPixel = "rgb";
      };

      katerc."KTextEditor Renderer"."Text Font" = "CaskaydiaCove Nerd Font,...";

      # KWin configuration for blur and magic lamp effects
      kwinrc = {
        # Set kde effects
        Plugins = {
          magiclampEnabled = true;
          squashEnabled = false;
          blurEnabled = true;
        };
        # Better blur effect settings
        Effect-blur = {
          Saturation = 275;
          BlurStrength = 8;
        };
        # Disable middle-click pasting
        Wayland.EnablePrimarySelection = false;
      };

      kiorc.Confirmations = {
        ConfirmDelete = true;
        ConfirmEmptyTrash = true;
      };

      # Krunner configuration for enabling/disabling plugins and setting favorites
      krunnerrc = {
        General.FreeFloating = true;
        # Enable/disable krunner plugins
        Plugins = {
          baloosearchEnabled = false;
          browserhistoryEnabled = false;
          browsertabsEnabled = false;
          helprunnerEnabled = false;
          krunner_appstreamEnabled = false;
          krunner_bookmarksrunnerEnabled = false;
          krunner_charrunnerEnabled = false;
          krunner_katesessionsEnabled = false;
          krunner_konsoleprofilesEnabled = false;
          krunner_placesrunnerEnabled = false;
          krunner_recentdocumentsEnabled = false;
          krunner_sessionsEnabled = false;
          krunner_spellcheckEnabled = true;
          krunner_webshortcutsEnabled = false;
          locationsEnabled = false;
          "org.kde.activities2Enabled" = false;
          "org.kde.datetimeEnabled" = false;
          unitconverterEnabled = true;
          windowsEnabled = false;
        };
        # Set the favorite plugins for krunner
        "Plugins/Favorites".plugins = "krunner_powerdevil,krunner_services,krunner_systemsettings";
      };

      # Spectacle configuration for clipboard and save locations
      spectaclerc = {
        General.clipboardGroup = "PostScreenshotCopyImage";
        ImageSave.translatedScreenshotsFolder = "Screenshots";
        VideoSave.translatedScreencastsFolder = "Screencasts";
      };
    };

    # Custom Keyboard Shortcuts
    shortcuts = {
      "services/kitty.desktop"._launch = "Meta+Return";
    };
  };

  # Extra breeeze folder icons
  home.file = {
    ".local/share/icons/breeze/places".source = ../../files/icons/places;
    ".local/share/icons/breeze-dark/places".source = ../../files/icons/places;
  };

}
