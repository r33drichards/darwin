{ config, pkgs, lib, ... }:


{
  # Run the linux-builder as a background service
  nix.linux-builder.enable = true;

  # Add needed system-features to the nix daemon
  # Starting with Nix 2.19, this will be automatic
  nix.settings.system-features = [
    "nixos-test"
    "apple-virt"
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

  environment.systemPackages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    pkgs.vscode
    pkgs.git
    pkgs.emacs
    # ssh
    pkgs.openssh
    pkgs.nix-direnv
    # pip
    pkgs.nixpkgs-fmt
    pkgs.tailscale
  ];

  nixpkgs.config.allowUnfree = true;
  services.tailscale.enable = true;
  security.pam.enableSudoTouchIdAuth = true;

  # todo tailscale up --ssh 
  # https://tailscale.com/kb/1215/oauth-clients#registering-new-nodes-using-oauth-credentials

  launchd.daemons.tailscale = {
    serviceConfig = {
      RunAtLoad = true;
      StandardOutPath = "/tmp/tailscale.out.log";
      StandardErrorPath = "/tmp/tailscale.err.log";
    };
    script = with  pkgs;''
      echo "tailscale up"

      source ${config.system.build.setEnvironment}
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        echo "tailscale is already running"
        exit 0
      fi
      ${pkgs.tailscale}/bin/tailscale up --ssh
    '';
  };


  launchd.agents.pf3000 = {
    serviceConfig = {
      RunAtLoad = true;
      StandardOutPath = "/tmp/pf3000.out.log";
      StandardErrorPath = "/tmp/pf3000.err.log";
    };
    script = with  pkgs;''
      ssh \
        -N \
        -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no \
        -o ServerAliveInterval=60 \
        -o ServerAliveCountMax=3 \
        -L 3000:localhost:3000 alice@dev
    '';
  };



}
