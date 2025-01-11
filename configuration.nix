{ config, pkgs, lib, ... }:


let
  assumeAWSRole = import ./assume-aws-role.nix { inherit pkgs; };
in

{
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
  services.nix-daemon.enable = true;
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
    warp-terminal
    transmission
    earthly
    pkgs.thefuck
    ripgrep
    spotify
    atuin
    slack
    watch
    nodejs
    ripgrep
    # Add the assume-aws-role application
    assumeAWSRole
  ];



  nixpkgs.config.allowUnfree = true;
  # services.tailscale.enable = true;
  security.pam.enableSudoTouchIdAuth = true;

  environment.variables.HOMEBREW_NO_ANALYTICS = "1";

  homebrew = {

    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    # masApps = {
    #   Tailscale = 1475387142; # App Store URL id
    #   Bitwarden = 1352778147;
    #   Excel = 462058435;
    # };
    ## install amethyst cask
    casks = [
    ];






  };
}
