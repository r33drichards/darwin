{ config, pkgs, lib, ... }:

{
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



  # ssh \
  #   -o UserKnownHostsFile=/dev/null \
  #   -o StrictHostKeyChecking=no \
  #  -N \
  #   -L 3000:localhost:3000 alice@dev

}
