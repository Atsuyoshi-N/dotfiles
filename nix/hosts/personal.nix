{ pkgs, ... }:

{
  # Personal Mac specific settings

  # Additional casks for personal use
  homebrew.casks = [
    "anki"
    "notion"
    "obsidian"
    "iterm2"
    # kindle is no longer available via Homebrew (install from App Store)
  ];
}
