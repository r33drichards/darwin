{ config, pkgs, lib, ... }:


let
  assumeAWSRole = import ./assume-aws-role.nix { inherit pkgs; };

in

{
  # Set the system state version for nix-darwin
  system.stateVersion = 6;
  system.primaryUser = "robertwendt";

  # Determinate Nix manages its own daemon
  nix.enable = false;

  # Run the linux-builder as a background service

  # TODO: linux-builder requires nix.enable, incompatible with Determinate Nix
  nix.linux-builder = {
    enable = false;
    ephemeral = true;
    maxJobs = 4;
    supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
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
    glibtool
    # pkgs.vscode
    pkgs.git
    pkgs.emacs
    # ssh
    pkgs.openssh
    pkgs.nix-direnv
    # pip
    pkgs.nixfmt
    pkgs.nixpkgs-fmt
    # pkgs.tailscale
    pkgs.awscli2
    pkgs.google-cloud-sdk
    # transmission
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
    # Spell checker for Emacs flyspell
    aspell
    aspellDicts.en
    # SSH tunnel auto-reconnect
    autossh
    uv
  ];



  nixpkgs.config.allowUnfree = true;
  # services.tailscale.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  environment.variables.HOMEBREW_NO_ANALYTICS = "1";

  # Persistent SSH tunnel for opencost with auto-reconnect
  launchd.user.agents = {
    ssh-tunnel-opencost = {
      serviceConfig = {
        Label = "com.user.ssh-tunnel-opencost";
        ProgramArguments = [
          "${pkgs.autossh}/bin/autossh"
          "-M" "0"
          "-o" "ServerAliveInterval=30"
          "-o" "ServerAliveCountMax=3"
          "-o" "ExitOnForwardFailure=yes"
          "-o" "StrictHostKeyChecking=no"
          "-o" "UserKnownHostsFile=/dev/null"
          "-i" "/Users/robertwendt/.ssh/rw.pem"
          "-L" "9091:localhost:29091"
          "-L" "9003:localhost:29003"
          "root@44.225.11.224"
          "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml && kubectl port-forward -n opencost deploy/opencost 29091:9091 29003:9003"
        ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/tmp/ssh-tunnel-opencost.log";
        StandardErrorPath = "/tmp/ssh-tunnel-opencost.err";
      };
    };
  };

}
