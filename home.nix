{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "robertwendt";
  home.homeDirectory = "/Users/robertwendt";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.vscode
    pkgs.git
    pkgs.mosh
    pkgs.emacs
    # ssh
    pkgs.openssh
    pkgs.nix-direnv
    pkgs.thefuck
    pkgs.poetry
    # pip
    pkgs.python3Packages.pip
    pkgs.nixpkgs-fmt
    pkgs.tailscale
    # pkgs.syncthing todo add me later
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:

    #     git init --initial-branch=main
    # git remote add origin git@gitlab.com:reedrichards/home-manager.git
    # git add .
    # git commit -m "Initial commit"
    # git push --set-upstream origin main

    # cd into icloud dir
    (pkgs.writeShellScriptBin "ic" ''
      cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/
    '')
    (pkgs.writeShellScriptBin "pf" ''
      ssh -L $1:localhost:$1 alice@dev
    '')
    (pkgs.writeShellScriptBin "pff" ''
      ssh -L $1:localhost:$2 alice@dev
    '')
    # nix run nix-darwin -- switch --refresh --flake github:r33drichards/darwin
    (pkgs.writeShellScriptBin "switch" ''
      nix run nix-darwin -- switch --refresh --flake github:r33drichards/darwin
    '')
    # (pkgs.writeShellScriptBin "cdhm" "cd ~/.config/home-manager")
  ];
  programs.zsh = {
    enable = true;
    enableCompletion = false; # enabled in oh-my-zsh
    initExtra = ''
      export NIXPKGS_ALLOW_UNFREE=1 
      eval "$(direnv hook $SHELL)"
      export PATH=/opt/homebrew/bin:$PATH
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "robbyrussell";
    };
  };


  programs.git = {
    enable = true;
    userName = "rw";
    userEmail = "rw@jjk.is";
  };

  # configure aliases

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.git-credential-oauth = {
    enable = true;
  };

}
