{ ... }:

{
  system.defaults = {
    # Dock
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      orientation = "left";
      tilesize = 32;
      show-recents = false;
    };

    # Finder
    finder = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
    };

    # Keyboard
    NSGlobalDomain = {
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };

    # .DS_Store
    CustomUserPreferences = {
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
    };

    # Clock format
    menuExtraClock = {
      Show24Hour = true;
      ShowSeconds = true;
    };
  };
}
