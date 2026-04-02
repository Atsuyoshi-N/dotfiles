{ pkgs, ... }:

{
  # Enable zsh as a login shell
  programs.zsh.enable = true;

  # zsh plugins - sourced in .zshrc via _plugin_base path detection
  environment.systemPackages = with pkgs; [
    zsh-abbr
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
  ];

  # Ensure plugin files are linked into /run/current-system/sw/share/
  environment.pathsToLink = [
    "/share/zsh-abbr"
    "/share/zsh-autosuggestions"
    "/share/zsh-syntax-highlighting"
    "/share/zsh"
  ];
}
