{ config, pkgs, lib, ... }:


{
  # Run the linux-builder as a background service
  nix.linux-builder.enable = true;

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

  nix.settings.trusted-users = [ "rw" ];

  # Set your system's hostname

  # Users configuration
  users.users.rw = {
    home = "/Users/rw";
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
    pkgs.vscode
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
  ];

  nixpkgs.config.allowUnfree = true;
  # services.tailscale.enable = true;
  security.pam.enableSudoTouchIdAuth = true;

  # todo tailscale up --ssh 
  # https://tailscale.com/kb/1215/oauth-clients#registering-new-nodes-using-oauth-credentials

  # launchd.daemons.tailscale = {
  #   serviceConfig = {
  #     RunAtLoad = true;
  #     StandardOutPath = "/tmp/tailscale.out.log";
  #     StandardErrorPath = "/tmp/tailscale.err.log";
  #   };
  #   script = with  pkgs;''
  #     echo "tailscale up"

  #     source ${config.system.build.setEnvironment}
  #     sleep 2

  #     # check if we are already authenticated to tailscale
  #     status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
  #     if [ $status = "Running" ]; then # if so, then do nothing
  #       echo "tailscale is already running"
  #       exit 0
  #     fi
  #     ${pkgs.tailscale}/bin/tailscale up --ssh
  #   '';
  # };

  launchd.agents.tailscaled = {
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/tailscaled.out.log";
      StandardErrorPath = "/tmp/tailscaled.err.log";
    };
    script = with  pkgs; ''
      ${tailscale}/bin/tailscaled
    '';
  };

  launchd.agents.pf3000 = {
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/pf3000.out.log";
      StandardErrorPath = "/tmp/pf3000.err.log";
    };
    script = with  pkgs; ''
      ssh -N -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -L 3000:localhost:3000 alice@devenv
    '';
  };

  launchd.agents.pf8000 = {
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/pf8000.out.log";
      StandardErrorPath = "/tmp/pf8000.err.log";
    };
    script = with  pkgs;''
      ssh -N -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -L 8000:localhost:8000 alice@devenv
    '';
  };

  launchd.agents.pf8080 = {
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/pf8080.out.log";
      StandardErrorPath = "/tmp/pf8080.err.log";
    };
    script = with  pkgs;''
      ssh -N -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -L 8080:localhost:8080 alice@devenv
    '';
  };

  launchd.agents.pf8081 = {
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/pf8081.out.log";
      StandardErrorPath = "/tmp/pf8081.err.log";
    };
    script = with  pkgs;''
      ssh -N -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -L 8081:localhost:8081 alice@devenv
    '';
  };
  launchd.agents.pf4000 = {
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/pf4000.out.log";
      StandardErrorPath = "/tmp/pf4000.err.log";
    };
    script = with  pkgs;''
      ssh -N -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -L 4000:localhost:4000 alice@devenv
    '';
  };



}
