{ config, pkgs, lib, ... }:

{
  # Set your system's hostname

  # Users configuration
  users.users.rw = {
    home = "/Users/rw";
    createHome = true; # Ensures the home directory is created
  };
  services.nix-daemon.enable = true;

  environment.systemPackages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.vscode
    pkgs.git
    pkgs.mosh
    pkgs.emacs
    # ssh
    pkgs.openssh
    pkgs.nix-direnv
    pkgs.thefuck
    pkgs.poetry
    # pip
    pkgs.python3Packages.pip
    pkgs.nixpkgs-fmt
    pkgs.tailscale
  ];

}
