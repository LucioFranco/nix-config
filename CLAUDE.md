# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal Nix configuration repository using **flake-parts** for modular configuration management. It supports both **nix-darwin** (macOS) and **NixOS** (Linux/WSL) systems with **home-manager** for user environment configuration.

## System Architecture

### Three-Layer Configuration Structure

1. **Flake Layer** (`flake.nix`): Top-level flake using flake-parts pattern
   - Defines inputs (nixpkgs, home-manager, darwin, etc.)
   - Sets up perSystem configuration for all supported platforms
   - Configures overlays, packages, and development shells
   - Uses treefmt for formatting and pre-commit hooks

2. **System Layer** (`nix/darwin.nix`, `nix/nixos.nix`): System-specific configurations
   - `nix/darwin.nix`: Darwin (macOS) system configurations (caserta, workbook)
   - `nix/nixos.nix`: NixOS configurations (wsl)
   - Both integrate home-manager and pass through `inputs` as specialArgs

3. **Host Layer** (`hosts/`): Individual machine configurations
   - `hosts/caserta.nix`, `hosts/workbook.nix`: macOS machines
   - `hosts/wsl.nix`: WSL2 Linux configuration
   - Each host imports `../home` for user configuration

### Home Manager Configuration

- **Entry point**: `home/default.nix`
- **Modular imports**: Each tool/program has its own file (zsh.nix, git.nix, nvim/, etc.)
- **Platform awareness**: Uses `pkgs.stdenv.isDarwin` for macOS-specific logic
- **Application handling**: Custom activation script copies apps to `~/Applications/Home Manager Apps/` (Darwin only)

### Custom Packages

- **Location**: `pkgs/default.nix`
- **Overlay**: Exposed via `overlays.additions` in `nix/overlays.nix`
- **Custom tools**:
  - `window`: Rust-based window management (matklad/window)
  - `spr`: Stack pull requests (sunshowers/spr)
  - `jj-github-pr`: Python tool for jujutsu GitHub PR integration
  - `compare`: Python comparison utility
  - `n`, `xdg-open-wsl`, `jjj`: Various utilities

## Development Commands

### Building and Deploying

```bash
# Deploy configuration to a host (NOTE: ./bin/deploy does not exist in current tree)
# Instead, use darwin-rebuild or nixos-rebuild directly:

# For Darwin (macOS) systems:
darwin-rebuild switch --flake .#caserta
darwin-rebuild switch --flake .#workbook

# For NixOS systems:
sudo nixos-rebuild switch --flake .#wsl

# Build without activating
nix build .#darwinConfigurations.caserta.system
nix build .#nixosConfigurations.wsl.config.system.build.toplevel
```

### Formatting and Linting

```bash
# Format all files (uses treefmt with nixfmt, ruff-format, shfmt)
nix fmt

# Check formatting without modifying
nix flake check

# Enter development shell (includes pre-commit hooks)
nix develop
```

### Building Custom Packages

```bash
# Build custom packages
nix build .#window
nix build .#spr
nix build .#jj-github-pr
nix build .#compare

# Build system packages
nix build .#workbook    # Darwin system
nix build .#wsl         # NixOS WSL system
```

### Testing and CI

The repository uses GitHub Actions for CI (`.github/workflows/ci.yml`). Pre-commit hooks enforce:
- `shellcheck` for shell scripts
- `ruff` for Python
- `treefmt` for Nix formatting

## Important Patterns

### Adding a New Darwin Host

1. Create `hosts/newhost.nix` following the pattern in `caserta.nix` or `workbook.nix`
2. Add entry in `nix/darwin.nix` using the same pattern
3. Optionally add to `.github/workflows/ci.yml` for CI checks

### Adding a Home Manager Module

1. Create new file in `home/` (e.g., `home/newtool.nix`)
2. Add import to `home/default.nix`
3. Configure the tool/program in the new file

### Adding a Custom Package

1. Add package definition to `pkgs/default.nix`
2. Package is automatically available via the `additions` overlay
3. Add to `home/default.nix` in `home.packages` to install it

### Working with Secrets

- Uses **ragenix** for age-encrypted secrets
- Secret definitions in `secrets.nix`
- Encrypted files in `hosts/wsl/` (e.g., `tailscale.age`, `home/atuin/key.age`)
- Public keys for two systems defined in `secrets.nix`

## Key Configuration Details

### Supported Systems

- `aarch64-darwin` (Apple Silicon macOS)
- `x86_64-linux` (NixOS/WSL)
- `aarch64-linux` (ARM Linux)

### Major Flake Inputs

- `nixpkgs`: Main package set (nixos-unstable)
- `home-manager`: User environment management
- `darwin`: nix-darwin for macOS system configuration
- `vim-config`: Custom vim configuration (LucioFranco/vim-config)
- `jujutsu`: Version control system (jj)
- `stylix`: System-wide theming
- `ragenix`: Age-based secret management
- `treefmt-nix`: Code formatting framework

### Home Manager Special Notes

- **Disabled module**: `targets/darwin/linkapps.nix` - replaced with custom activation
- **Darwin app installation**: Uses `copyApplications` activation script instead of symlinks (Spotlight compatibility)
- **Session variables**: Extensive Rust/C development environment setup in `home/default.nix`
- **Custom PATH additions**: `~/.toolbox/bin`, `~/.cargo/bin`, `~/code/install/bin`, etc.

### Overlays Chain

The overlay order matters (defined in flake.nix perSystem):
1. `vim-config.overlays.default`
2. `starship-jj.overlays.default`
3. `ragenix.overlays.default`
4. `jujutsu.overlays.default`
5. `nix-std` library overlay
6. `self.overlays.additions` (custom packages)
7. `self.overlays.modifications` (currently empty)
8. `self.overlays.unstable-packages` (currently empty)

## Notes for Claude

- **No bin/deploy script exists**: Use `darwin-rebuild` or `nixos-rebuild` directly
- **Formatting is enforced**: All changes must pass `nix fmt` and pre-commit hooks
- **Flake-parts pattern**: Understand the `withSystem` and `perSystem` structure
- **Home-manager integration**: Both nixos and darwin modules use identical home-manager setup pattern
- **Custom tools are important**: The user maintains several custom tools (window, spr, jj-github-pr, etc.)
