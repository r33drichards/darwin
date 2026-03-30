{ config, pkgs, lib, ... }:


let
  assumeAWSRole = import ./assume-aws-role.nix { inherit pkgs; };

  # SSH tunnel configuration
  sshKeyPath = "/Users/robertwendt/Downloads/rw.pem";
  bastionHost = "3.80.51.36";

  # Helper function to create SSH tunnel launchd agents
  mkSshTunnel = { name, localPort, remoteHost, remotePort, user ? "root" }: {
    serviceConfig = {
      Label = "com.user.ssh-tunnel-${name}";
      ProgramArguments = [
        "${pkgs.autossh}/bin/autossh"
        "-M" "0"  # Disable autossh monitoring port, use ServerAlive instead
        "-N"      # No remote command
        "-o" "ServerAliveInterval=30"
        "-o" "ServerAliveCountMax=3"
        "-o" "ExitOnForwardFailure=yes"
        "-o" "StrictHostKeyChecking=no"
        "-o" "UserKnownHostsFile=/dev/null"
        "-i" sshKeyPath
        "-L" "${toString localPort}:${remoteHost}:${toString remotePort}"
        "${user}@${bastionHost}"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/ssh-tunnel-${name}.log";
      StandardErrorPath = "/tmp/ssh-tunnel-${name}.err";
    };
  };
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
    pkgs.tailscale
    pkgs.awscli2
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
    claude-code
    # Spell checker for Emacs flyspell
    aspell
    aspellDicts.en
    # SSH tunnel auto-reconnect
    autossh
  ];



  nixpkgs.config.allowUnfree = true;
  # services.tailscale.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  environment.variables.HOMEBREW_NO_ANALYTICS = "1";

  # Persistent SSH tunnels with auto-reconnect
  launchd.user.agents = {
    # VM5 - Port 8443 (existing tunnel)
    ssh-tunnel-vm5-8443 = mkSshTunnel {
      name = "vm5-8443";
      localPort = 8443;
      remoteHost = "10.5.0.2";
      remotePort = 8443;
    };

    # VM1 - RDP (existing tunnel)
    ssh-tunnel-vm1-rdp = mkSshTunnel {
      name = "vm1-rdp";
      localPort = 3389;
      remoteHost = "10.1.0.2";
      remotePort = 3389;
    };

    # VM2 - RDP
    ssh-tunnel-vm2-rdp = mkSshTunnel {
      name = "vm2-rdp";
      localPort = 3390;
      remoteHost = "10.2.0.2";
      remotePort = 3389;
    };

    # VM3 - RDP
    ssh-tunnel-vm3-rdp = mkSshTunnel {
      name = "vm3-rdp";
      localPort = 3391;
      remoteHost = "10.3.0.2";
      remotePort = 3389;
    };

    # VM4 - k3s API server
    ssh-tunnel-vm4-k3s = mkSshTunnel {
      name = "vm4-k3s";
      localPort = 6443;
      remoteHost = "10.4.0.2";
      remotePort = 6443;
    };

    # stable-kite - Port forward 33019 (direct connection, no bastion)
    ssh-tunnel-stable-kite = {
      serviceConfig = {
        Label = "com.user.ssh-tunnel-stable-kite";
        ProgramArguments = [
          "${pkgs.autossh}/bin/autossh"
          "-M" "0"
          "-N"
          "-o" "ServerAliveInterval=30"
          "-o" "ServerAliveCountMax=3"
          "-o" "ExitOnForwardFailure=yes"
          "-o" "StrictHostKeyChecking=no"
          "-o" "UserKnownHostsFile=/dev/null"
          "-L" "33019:127.0.0.1:33019"
          "root@stable-kite"
        ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/tmp/ssh-tunnel-stable-kite.log";
        StandardErrorPath = "/tmp/ssh-tunnel-stable-kite.err";
      };
    };
  };

}
