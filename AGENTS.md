# Romarchy Agent Guidelines

Romarchy is a personal dotfiles system for Arch Linux with Hyprland. This file provides guidelines for agents working on this codebase.

## Repository Structure

```
romarchy/
├── bin/                  # Executable scripts (launchers, power menu, etc.)
├── config/               # App configurations
│   └── hypr/            # Hyprland config (modular: bindings, envs, input, etc.)
├── default/              # Default configs (bash modular config)
├── install/              # Installation scripts and packs
│   ├── packs/           # Package installation scripts (01-core, 02-terminal, etc.)
│   ├── helpers/         # Shared install functions (check.sh, ui.sh)
│   └── post-install/    # Post-install setup scripts
├── scripts/              # Helper scripts
└── themes/              # Theme files
```

## Build/Test Commands

This is a dotfiles project, not a compiled application. Testing involves:

```bash
# Test a script
bash /path/to/script.sh

# Verify script is executable
test -x /path/to/script.sh && echo "executable" || echo "not executable"

# Check Hyprland config syntax
hyprctl reload

# Verify all scripts in bin/
for script in ~/.local/share/romarchy/bin/*; do
    bash -n "$script" && echo "OK: $script" || echo "FAIL: $script"
done
```

## Code Style Guidelines

### Bash Scripts

- **Shebang**: Always use `#!/bin/bash` (not `#!/bin/sh` unless POSIX-only)
- **Variables**: Lowercase with underscores, uppercase for environment/constants
  ```bash
  # Good
  local romarchy_dir="$HOME/.local/share/romarchy"
  export EDITOR=nvim
  
  # Avoid
  local RomarchyDir="..."
  local myVar="..."
  ```
- **Functions**: Lowercase with underscores, descriptive names
  ```bash
  check_and_install() { ... }
  setup_lazyvim() { ... }
  ```
- **Error handling**: Use `set -e` at top for critical scripts
- **Quoting**: Always quote variables containing paths
  ```bash
  # Good
  source "$ROMARCHY_DIR/install/helpers/check.sh"
  
  # Avoid
  source $ROMARCHY_DIR/install/helpers/check.sh
  ```
- **Conditional checks**: Use `[[ ]]` for bash conditionals, not `[ ]`
- **Array syntax**: Use `("${array[@]}")` for proper word splitting

### Hyprland Configuration

- **Organization**: Modular files in `config/hypr/`
  - `bindings.conf` - Keybindings
  - `envs.conf` - Environment variables
  - `input.conf` - Keyboard/touchpad settings
  - `looknfeel.conf` - General, decoration, animations
  - `monitors.conf` - Monitor configuration
  - `windowrules.conf` - Window rules
- **Comments**: Section headers with `#`, inline comments for complex bindings
- **Binding format**: `bindd = MOD, KEY, Description, dispatcher, args`
  - Use `$var` for repeated commands
  - Group related bindings with blank lines
- **Variables**: Use `$launcher`, `$terminal`, etc. for script paths

### File Organization

- **Scripts in `bin/`**: One script per file, focused purpose
- **Naming**: kebab-case for files, consistent prefixes
  - Launchers: `launch-*` (launch-terminal, launch-browser)
  - System: `romarchy-*` (romarchy-power-menu, romarchy-lock-screen)
- **Install packs**: Numbered prefixes for order (01-core, 02-terminal)

### Git Workflow

- **Commits**: Descriptive, action-based messages
  ```bash
  git commit -m "Add launch-editor script and LazyVim setup"
  git commit -m "Update README with new keybindings"
  ```
- **Push**: After meaningful changes
- **Branch**: Work on `main`

## Key Dependencies

- **Hyprland ecosystem**: hyprland, waybar, hyprlock, hypridle
- **Launchers**: walker, elephant, impala (wifi)
- **Terminal**: kitty with starship prompt
- **Editor**: Neovim with LazyVim
- **Package managers**: pacman, yay (AUR)

## Important Paths

- **Main directory**: `~/.local/share/romarchy/`
- **Symlinks**: Configs linked to `~/.config/`
- **Scripts**: Must be in `~/.local/share/romarchy/bin/` and in `$PATH`

## Adding New Features

1. **New script**: Create in `bin/` with executable permission
2. **New package**: Add to appropriate pack in `install/packs/`
3. **New config**: Add to `config/hypr/` and source in `hyprland.conf`
4. **New binding**: Add to `config/hypr/bindings.conf`
5. **Commit**: Small, focused commits with clear messages
6. **Push**: Regular pushes after logical groups of changes

## Testing Changes

```bash
# Make script executable
chmod +x ~/.local/share/romarchy/bin/new-script

# Reload Hyprland config
hyprctl reload

# Test script execution
~/.local/share/romarchy/bin/new-script

# Check if in PATH (after new shell)
which new-script
```

## Common Patterns

### Launcher Script
```bash
#!/bin/bash
uwsm-app -- <app-name>
```

### Power Menu Script
```bash
#!/bin/bash
# Use walker --dmenu mode or similar
```

### Install Pack
```bash
#!/bin/bash
ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
source "$ROMARCHY_DIR/install/helpers/check.sh"
source "$ROMARCHY_DIR/install/helpers/ui.sh"

check_and_install "PackName" \
  package1 \
  package2 \
  package3
```

## References

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Omarchy](https://github.com/basecamp/omarchy) - Inspiration
- [omarchy-theme-hook](https://github.com/imbypass/omarchy-theme-hook) - Theme syncing
