# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains a nix-darwin configuration for managing a macOS system using Nix flakes. It includes:

- **System configuration** (`configuration.nix`): MacOS system-level packages and services
- **Home Manager configuration** (`home.nix`): User-level packages and dotfiles
- **Emacs server application** (defined in `flake.nix`): Web-based Emacs accessible via gotty
- **Custom utilities**: AWS role assumption tool and shell scripts

## Essential Commands

### Building and Activating System Configuration

```bash
# Rebuild and switch to new configuration (preferred method)
sudo darwin-rebuild switch --flake .#rws-MacBook-Air

# Alternative: Apply system configuration from local flake
nix run nix-darwin -- switch --refresh --flake .

# Alternative: Apply specific host configuration
sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --refresh --flake .#rws-MacBook-Air

# Apply from remote (GitHub)
nix run nix-darwin -- switch --refresh --flake github:r33drichards/darwin
```

### Building Emacs Server

```bash
# Build the emacs-server package
nix build .#emacs-server

# Build Docker image
nix build .#dockerImage

# Run emacs-server directly
nix run .#emacs-server
```

### Development

```bash
# Enter development shell
nix develop

# Format Nix files
nixfmt <file.nix>
# or
nixpkgs-fmt <file.nix>
```

## Architecture

### Flake Structure

The `flake.nix` serves dual purposes:

1. **System configurations** via `darwinConfigurations` - defines the nix-darwin system for the `rws-MacBook-Air` host
2. **Application packages** via `packages` - builds the emacs-server application and Docker image using `flake-utils.lib.eachDefaultSystem`

### Key Files

- **flake.nix**: Orchestrates system and application outputs. The emacs-server package uses `writeShellApplication` to wrap gotty + emacs daemon
- **configuration.nix**: System-level configuration including nix-darwin settings, Linux builder VM setup for cross-platform builds, and system packages
- **home.nix**: User configuration managed by home-manager. Links init.el and sshconfig into the home directory
- **init.el**: Complete Emacs configuration (symlinked to ~/.emacs.d/init.el)
- **assume-aws-role.nix**: Defines the `aar` command-line tool for assuming AWS roles

### Linux Builder

The configuration includes a Linux builder VM (`nix.linux-builder`) that enables building Linux packages on macOS. This is configured with:
- 40GB disk, 8GB RAM, 6 cores
- Support for nixos-test, kvm, big-parallel features
- Ephemeral mode (recreated on each build)

### Custom Packages

Custom packages are built using `writeShellApplication` (e.g., `assume-aws-role.nix`) and imported into system packages via `let...in` bindings.

## Managing Dependencies

- Use nix for managing Rust dependencies and running cargo (per user global CLAUDE.md)
- System packages go in `configuration.nix`'s `environment.systemPackages`
- User packages go in `home.nix`'s `home.packages`
- Lock file updates: `nix flake update`

## Special Considerations

- Flake experimental features are enabled system-wide
- Linux builder is required for building Docker images on macOS
- Home Manager links files using `home.file.<name>.text = builtins.readFile ./path`
- System requires macOS (aarch64-darwin architecture)
