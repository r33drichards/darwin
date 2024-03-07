{ config, pkgs, lib, ... }:

{
  # Set your system's hostname

  # Users configuration
  users.users.robertwendt = {
    home = "/Users/robertwendt";
    createHome = true; # Ensures the home directory is created
  };
}