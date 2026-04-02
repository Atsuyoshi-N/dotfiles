{ pkgs, username, ... }:

{
  # Work Mac specific settings

  # Additional casks for work
  homebrew.casks = [
    "slack"
    "notion"
  ];

  # Work-specific CLI tools
  home-manager.users.${username}.home.packages = with pkgs; [
    # Add work-specific tools here
  ];

  # Git: use includeIf in .gitconfig for work email
  # Add to .gitconfig:
  #   [includeIf "gitdir:~/work/"]
  #     path = ~/.gitconfig-work
  #
  # Then create ~/.gitconfig-work with:
  #   [user]
  #     email = your-work-email@company.com
}
