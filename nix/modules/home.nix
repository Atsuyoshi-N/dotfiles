{ username, config, pkgs, lib, ... }:

let
  dotfilesPath = "/Users/${username}/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";

  # XDG config dirs to symlink: name -> source path in dotfiles repo
  xdgConfigs = {
    "nvim" = ".config/nvim";
    "ghostty" = ".config/ghostty";
    "gh" = ".config/gh";
    "lazygit" = ".config/lazygit";
    "zsh-abbr" = ".config/zsh-abbr";
    "git" = ".config/git";
  };
in
{
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # Core CLI tools
    bat
    fzf
    jq
    ripgrep
    tree
    wget

    # Git tools
    gh
    ghq
    lazygit
    tig
    hub

    # Editor
    neovim
    vim
    vimpager

    # Shell
    tmux
    zsh

    # Languages
    go
    lua

    # Build tools
    cmake
    gnused
  ];

  # Symlink existing dotfiles into $HOME
  home.file = {
    ".zshrc".source = mkLink ".zshrc";
    ".zshenv".source = mkLink ".zshenv";
    ".tmux.conf".source = mkLink ".tmux.conf";
    ".gitconfig".source = mkLink ".gitconfig";
    ".gitignore_global".source = mkLink ".gitignore_global";
    ".tigrc".source = mkLink ".tigrc";
    ".vimrc".source = mkLink ".vimrc";
    ".ideavimrc".source = mkLink ".ideavimrc";
    ".vim" = {
      source = mkLink ".vim";
      force = true;
    };
    ".zsh-interactive-cd.plugin.zsh".source = mkLink ".zsh-interactive-cd.plugin.zsh";
  };

  # XDG config directories: managed via activation script to avoid
  # home-manager clobbering ~/dotfiles/.config/ (which is under $HOME).
  home.activation.linkXdgConfigs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    CONFIG_DIR="/Users/${username}/.config"
    mkdir -p "$CONFIG_DIR"
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: src: ''
      LINK="$CONFIG_DIR/${name}"
      TARGET="${dotfilesPath}/${src}"
      if [ -L "$LINK" ]; then
        rm "$LINK"
      fi
      ln -sfn "$TARGET" "$LINK"
    '') xdgConfigs)}
  '';

  programs.home-manager.enable = true;
}
