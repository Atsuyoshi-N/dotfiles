{ self, username, hostname, pkgs, ... }:

{
  imports = [
    ./darwin-defaults.nix
    ./homebrew.nix
    ./shell.nix
  ];

  # Nix daemon is managed by Determinate Systems installer, not nix-darwin
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;

  # System
  networking.hostName = hostname;
  system.stateVersion = 5;

  # Primary user (required by nix-darwin for user-specific system settings)
  system.primaryUser = username;

  # User
  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  # home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit self username; };
    users.${username} = import ./home.nix;
  };

  # Allow Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
}
