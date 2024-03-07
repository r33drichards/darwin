{ config, pkgs, lib, ... }:

{
  # Set your system's hostname
  networking.hostName = "Roberts-MacBook-Air"; # Change this to your desired hostname

  # Users configuration
  users.users.robertwendt = {
    isNormalUser = true;
    home = "/Users/robertwendt";
    createHome = true; # Ensures the home directory is created
    extraGroups = [ "wheel" ]; # Adds the user to additional groups, e.g., wheel for sudo
    shell = pkgs.zsh; # Sets the default shell for the user
  };
}