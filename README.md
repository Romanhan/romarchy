# Romarchy

Personal dotfiles for Arch Linux with Hyprland.

## Structure

```
romarchy/
├── bin/           # Scripts (launchers, power menu, etc.)
├── config/        # App configs (hypr, waybar, kitty, etc.)
├── install/       # Install scripts for packages
├── scripts/       # Helper scripts
└── themes/        # Theme files
```

## Installation

### Fresh Install

1. Clone the repo:
```bash
git clone https://github.com/romanhan/romarchy.git ~/.local/share/romarchy
```

2. Run install scripts:
```bash
~/.local/share/romarchy/install/romarchy-install
```

### Symlinks

Configs are symlinked to `~/.config/`:
```bash
~/.config/hypr      -> ~/.local/share/romarchy/config/hypr
~/.config/waybar    -> ~/.local/share/romarchy/config/waybar
~/.config/kitty     -> ~/.local/share/romarchy/config/kitty
~/.config/walker    -> ~/.local/share/romarchy/config/walker
~/.config/wofi      -> ~/.local/share/romarchy/config/wofi
~/.config/elephant  -> ~/.local/share/romarchy/config/elephant
```

## Keybindings

| Key | Action |
|-----|--------|
| Super + Space | App launcher (Walker) |
| Super + Escape | Power menu |
| Super + Shift + L | Lock screen |
| Super + T | Terminal |
| Super + N | Editor (LazyVim) |
| Super + B | Browser |
| Super + E | File manager |
| Super + Y | Yazi file manager |

## Packages

Installed via `romarchy-install`:

- **Core**: hyprland, waybar, hyprlock, hypridle, uwsm
- **Terminal**: kitty, starship, eza, bat, fd, ripgrep
- **Launchers**: walker, elephant, impala (wifi)
- **Utils**: wl-clipboard, grim, slurp, mako, bluetui, yazi
- **Dev**: git, neovim, fzf, zoxide
- **Extras**: fastfetch, fonts, LazyVim

## Inspired by

[Omarchy](https://github.com/basecamp/omarchy) - Beautiful, Modern & Opinionated Linux distribution
