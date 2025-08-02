{ config, pkgs, lib, ... }:


let
  assumeAWSRole = import ./assume-aws-role.nix { inherit pkgs; };
in

{
  # Set the system state version for nix-darwin
  system.stateVersion = 6;

  # Run the linux-builder as a background service

  nix.linux-builder = {
    enable = true;
    ephemeral = true;
    maxJobs = 4;
    config = {
      virtualisation = {
        darwin-builder = {
          diskSize = 40 * 1024;
          memorySize = 8 * 1024;
        };
        cores = 6;
      };
    };
  };

  nix.settings.substituters = [
    "https://nix-community.cachix.org"
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  # Add needed system-features to the nix daemon
  # Starting with Nix 2.19, this will be automatic
  nix.settings.system-features = [
    "nixos-test"
    "apple-virt"
    "big-parallel"
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Makes it so things that require channels can still work
  # such as nix-shell
  nix.nixPath = [
    "nixpkgs=flake:nixpkgs"
  ];

  nix.settings.trusted-users = [ "robertwendt" ];

  # Set your system's hostname

  # Users configuration
  users.users.robertwendt = {
    home = "/Users/robertwendt";
    createHome = true; # Ensures the home directory is created
  };
  # nix-daemon is now managed automatically when nix.enable is on
  programs.zsh.enable = true;
  programs.direnv = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    cmake
    # pkgs.vscode
    pkgs.git
    pkgs.emacs
    # ssh
    pkgs.openssh
    pkgs.nix-direnv
    # pip
    pkgs.nixfmt
    pkgs.nixpkgs-fmt
    pkgs.tailscale
    transmission
    earthly
    ripgrep
    atuin
    slack
    watch
    nodejs
    ripgrep
    # Add the assume-aws-role application
    assumeAWSRole
    kubectl
    kubernetes-helm
  ];



  nixpkgs.config.allowUnfree = true;
  # services.tailscale.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  environment.variables.HOMEBREW_NO_ANALYTICS = "1";


}
