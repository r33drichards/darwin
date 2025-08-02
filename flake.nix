{
  description = "Darwin configuration and emacs server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ nixpkgs, home-manager, darwin, flake-utils, ... }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        
        # Build the emacs server application
        emacs-server = pkgs.writeShellApplication {
          name = "emacs-server";
          runtimeInputs = [ pkgs.gotty pkgs.emacs pkgs.bash ];
          text = ''
            export EMACS_CONFIG_DIR=${./.}
            gotty --permit-write --reconnect bash -c "emacsclient -t || (emacs --daemon --init-directory=$EMACS_CONFIG_DIR && emacsclient -t)"
          '';
          meta = with pkgs.lib; {
            description = "Web-based Emacs server using gotty";
            homepage = "https://github.com/yudai/gotty";
            license = licenses.mit;
            maintainers = [];
          };
        };

        # Docker image
        dockerImage = pkgs.dockerTools.buildLayeredImage {
          name = "emacs-server";
          tag = "latest";
          config.Cmd = [ "${emacs-server}/bin/emacs-server" ];
          config.Env = [ 
            "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
            "EMACS_CONFIG_DIR=/config"
          ];
          contents = [ 
            pkgs.cacert 
            pkgs.emacs 
            pkgs.gotty 
            pkgs.bash 
            emacs-server
          ];
        };

      in {
        packages = {
          default = emacs-server;
          emacs-server = emacs-server;
          dockerImage = dockerImage;
        };
        
        apps = {
          default = {
            type = "app";
            program = "${emacs-server}/bin/emacs-server";
          };
          emacs-server = {
            type = "app";
            program = "${emacs-server}/bin/emacs-server";
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            go
            gotty
            emacs
          ];
        };
      }
    ) // {
      darwinConfigurations = {
        rws-MacBook-Air = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./configuration.nix
            home-manager.darwinModules.home-manager 
                      {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.robertwendt = import ./home.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
          specialArgs = {
            inherit inputs;
          };
        };
      };
    };
}
