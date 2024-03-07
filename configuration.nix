{ config, pkgs, lib, ... }:

{
  # Set your system's hostname

  # Users configuration
  users.users.robertwendt = {
    isNormalUser = true;
    home = "/Users/robertwendt";
    createHome = true; # Ensures the home directory is created
    shell = pkgs.zsh; # Sets the default shell for the user
  };
}