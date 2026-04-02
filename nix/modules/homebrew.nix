{ ... }:

{
  # Homebrew itself must be installed separately.
  # nix-darwin uses it to manage casks declaratively.
  homebrew = {
    enable = true;

    onActivation = {
      # "zap" removes casks not listed here. Use "none" to be less aggressive.
      cleanup = "none";
      autoUpdate = true;
      upgrade = true;
    };

    taps = [ ];

    # GUI apps - Nix can't reliably install these on macOS
    casks = [
      # Browsers
      "firefox"
      "google-chrome"

      # Terminal
      "ghostty"

      # Editor
      "visual-studio-code"

      # Dev tools
      "docker-desktop"

      # Utilities
      "1password"
      "alt-tab"
      "rectangle"

      # Fonts
      "font-hack-nerd-font"
    ];

    # Homebrew formulae (for things not in nixpkgs or that work better via brew)
    brews = [ ];
  };
}
