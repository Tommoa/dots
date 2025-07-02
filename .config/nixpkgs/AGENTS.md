# Agent Guidelines for Nix Configuration Repository

## Build/Update Commands
- **Update system**: `./update-nix [system|home|both] [config-name]` (auto-detects: apollo, james)
- **Test configuration**: `nix flake check` (validates flake syntax and builds)
- **Build specific config**: `nix build .#homeConfigurations."toma@work".activationPackage`
- **Test single config**: `nix build .#darwinConfigurations.apollo.system` or `nix build .#nixosConfigurations.james.config.system.build.toplevel`
- **Dry run**: Add `--dry-run` to darwin-rebuild/nixos-rebuild commands

## Code Style Guidelines
- **File structure**: Use modular approach with profiles in `modules/{darwin,nixos,home-manager}/profiles/`
- **Imports**: Place at top of file, use relative paths (`../modules/...`)
- **Formatting**: 2-space indentation, no trailing whitespace, empty line after imports
- **Comments**: Use `#` for explanatory comments, avoid inline comments
- **Naming**: Use kebab-case for files (`base.nix`), camelCase for attributes
- **Package lists**: Use `with pkgs;` pattern, alphabetical ordering, group by category
- **Conditionals**: Use `pkgs.stdenv.isLinux`/`pkgs.stdenv.isDarwin` for platform detection
- **Helper functions**: Define in `let...in` blocks with descriptive names
- **Attributes**: Use explicit attribute sets, avoid unnecessary nesting

## Configuration Structure
- **Hosts**: `hosts/{apollo,james}.nix` for system-specific configs
- **Profiles**: Reusable modules in `modules/*/profiles/` (base, desktop, development, server)
- **Common**: Shared modules in `modules/common/` (base, fonts, nix)
- **Overlays**: Custom packages in `overlays/` directory, compose with `//` operator
- **Flake outputs**: homeConfigurations, darwinConfigurations, nixosConfigurations

## Error Handling
- Always validate flake syntax before committing: `nix flake check`
- Test configurations in isolated builds before switching
- Use `nix eval` to check attribute existence before referencing
- Check available configs: `nix eval .#homeConfigurations --apply builtins.attrNames`
