# AGENTS.md - Development Guidelines for Utopia Planitia

## Build/Test/Lint Commands
- **Build system**: `./bin/build` (auto-detects Darwin/Linux and calls appropriate build script)
- **Apply configuration**: `./bin/apply` (interactive setup script for new systems)
- **Darwin build**: `./bin/darwin-build` (macOS-specific build)
- **NixOS build**: `./bin/nixos-build` (Linux-specific build)
- **Flake build**: `nix build` (standard Nix flake commands)
- **Check flake**: `nix flake check`
- **Update flake**: `nix flake update`

## Code Style Guidelines
- **Language**: Nix expressions (.nix files)
- **Indentation**: 2 spaces (consistent across all .nix files)
- **Formatting**: Use nixfmt or similar Nix formatter
- **Imports**: Group imports logically, system inputs first
- **Naming**: Use kebab-case for file/directory names, camelCase for Nix attributes
- **Comments**: Use `#` for single-line comments, avoid inline comments unless necessary
- **Structure**: Follow Snowfall Lib conventions for flake organization
- **Error handling**: Use `lib.mkIf` and `lib.mkDefault` for conditional configurations

## Project Structure
- Uses Snowfall Lib for flake organization with namespace "replicator"
- Systems in `systems/` (Darwin, NixOS, ARM builds)
- Home Manager configs in `homes/`
- Modules in `modules/` (darwin/, home/)
- Custom packages in `packages/`
- Overlays in `overlays/`
- Personal dotfiles in `dotfiles/`. These get symlinked into various places when the system configuration is applied
