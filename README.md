# Romarchy

Beautiful, Modern & Opinionated Arch Linux + Hyprland setup.

## Fresh Install

### Step 1: Install Arch Linux

Download the [Arch Linux ISO](https://archlinux.org/download/), put it on a USB stick, and boot from it.

Run `archinstall` with these settings:

| Option | Value |
|--------|-------|
| Filesystem | BTRFS + compression |
| Encryption | LUKS (REQUIRED) |
| Bootloader | Limine |
| Audio | Pipewire |
| Network | NetworkManager |

### Step 2: Install Romarchy

```bash
git clone https://github.com/Romanhan/romarchy.git ~/.local/share/romarchy
~/.local/share/romarchy/install/romarchy-install
```

### Step 3: Reboot

- Plymouth shows password dialog (LUKS)
- Loading bar with progress
- Direct UKI boot (no menu)

## Features

- **Snapshots**: `snapshot create/list/restore`
- **Themes**: Multiple themes with automatic switching
- **Bootloader**: Limine with direct UKI boot
- **Encryption**: LUKS with Plymouth password dialog
- **Shell**: Kitty + Starship prompt
- **WiFi**: iwd + NetworkManager (Qualcomm Atheros support)
- **Hardware Detection**: Automatic detection for ASUS ROG, Framework, Surface, Intel, Vulkan
- **GTK/Icon Theming**: Full GTK3/GTK4 theming with adw-gtk-theme and Yaru icons

## Structure

```
romarchy/
├── bin/           # Scripts (launchers, power menu, hw detection, etc.)
├── config/        # App configs (hypr, waybar, kitty, etc.)
├── default/       # Default configs (limine, plymouth)
├── install/       # Installation scripts
│   ├── helpers/   # Shared functions (check.sh, ui.sh, errors.sh, logging.sh)
│   ├── preflight/ # System checks (guard.sh, disable-mkinitcpio.sh)
│   ├── packs/     # Package installation (01-core, 02-terminal, etc.)
│   ├── config/    # Config copying + hardware setup
│   ├── login/     # Limine + Snapper setup
│   └── post-install/ # Post-install services
└── AGENTS.md
```

## Hardware Detection

Automatic hardware detection enables machine-specific configurations:

| Script | Detects |
|--------|--------|
| `hw-asus-rog` | ASUS ROG laptops |
| `hw-intel` | Intel CPUs |
| `hw-framework16` | Framework Laptop 16 |
| `hw-surface` | Microsoft Surface |
| `hw-vulkan` | Vulkan support |
| `hw-nvidia` | NVIDIA GPUs |
| `hw-match` | Match DMI product name |

Used in install scripts for conditional configurations (e.g., Intel-specific fixes).

## WiFi

Uses iwd for WiFi connections + NetworkManager for DHCP/DNS:

- Works with **all WiFi cards** (Qualcomm Atheros, Intel, etc.)
- Power save rules for laptops (on battery)
- Hardware detection for WiFi card type (`wifi-is-qualcomm`, `wifi-is-intel`)

## Installation Flow

```
romarchy-install
├── helpers/all.sh (load helpers)
├── preflight/all.sh (Arch, BTRFS, LUKS, Limine checks)
├── packs/all.sh (install packages)
├── config/all.sh (copy configs)
├── login/all.sh (limine + snapper)
└── post-install/all.sh (services, LazyVim, EFI entries)
```

## Keybindings

| Key | Action |
|-----|--------|
| Super + Space | App launcher (Walker) |
| Super + Escape | Power menu |
| Super + Ctrl + L | Lock screen |
| Super + T | Terminal |
| Super + N | Editor (LazyVim) |
| Super + B | Browser |
| Super + E | File manager |
| Super + Y | Yazi file manager |
| Super + Shift + A | AI Picker (Grok, Gemini, ChatGPT, Claude) |
| Super + Shift + Y | YouTube |
| Print | Screenshot (region) |
| Shift + Print | Screenshot (fullscreen) |
| Super + Alt + , | Edit last screenshot (Satty) |
| Super + , | Dismiss last notification |
| Super + Shift + , | Dismiss all notifications |
| Super + Ctrl + Alt + T | Show time |
| Super + Ctrl + Alt + B | Show battery status |

## Screenshot

Screenshot system inspired by [Omarchy](https://github.com/basecamp/omarchy):

- **Print** — select region, saves to `~/Pictures/Screenshots/`, copies to clipboard
- **Shift + Print** — fullscreen screenshot, same flow
- Notification appears with "Edit" button — click to open in **Satty** (annotation editor with arrows, lines, blur, text)
- **Super + Alt + ,** — edit last screenshot in Satty
- **Super + Alt + ,** on notification — re-invoke last notification

### Satty Editor

Annotation tools available:
- Pointer, Crop, Arrow, Line, Rectangle, Ellipse, Text, Marker, Blur, Brush
- Press Enter — copy to clipboard
- Press Escape — exit

## Web Apps

### AI Apps
Installed automatically via `ai-install`:
- Grok (grok.com)
- Gemini (gemini.google.com)
- ChatGPT (chatgpt.com)
- Claude (claude.ai)

Access via:
- App launcher (`Super + Space`) - search for app name
- AI Picker (`Super + Shift + A`) - quick select menu

### Installation

```bash
# Install AI web apps
ai-install

# Install web app manually (via menu)
launch-menu → Web Apps → Install Web App
```

## Theme Switching

Full dynamic theme system inspired by [Omarchy](https://github.com/basecamp/omarchy):

### Available Commands

```bash
# Switch theme
theme-set <theme-name>

# List available themes
theme-list

# Show current theme
theme-current

# Cycle background
bg-next
```

### Supported Apps

| App | Theme Method |
|-----|-------------|
| **Waybar** | Updates style.css from theme |
| **GTK/GNOME** | gsettings (gtk-theme, icon-theme, color-scheme) |
| **Nautilus** | GTK theming |
| **Mako** | Symlinks mako.ini |
| **Walker** | Copies walker.css |
| **btop** | current.theme symlink + color_theme = "current" |
| **SwayOSD** | Generates theme.css |
| **Hyprlock** | Generates theme.conf |
| **Kitty** | Generates theme.conf |
| **Ghostty** | Generates theme.conf |
| **OpenCode** | SIGUSR2 to reload config |
| **Neovim** | Copies nvim.lua to plugins |
| **Background** | Updates swaybg with theme background |

### Supported Themes

Comes with 20+ themes including:
- catppuccin-mocha-black (default)
- osaka-jade
- tokyo-night
- nord
- gruvbox
- everforest
- rose-pine
- and more...

## Inspired by

[Omarchy](https://github.com/basecamp/omarchy) - Beautiful, Modern & Opinionated Linux distribution

## License

Personal dotfiles project.
