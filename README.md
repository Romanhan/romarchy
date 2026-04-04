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

- **Snapshots**: `romarchy-snapshot create/list/restore`
- **Themes**: Catppuccin Mocha (dark)
- **Bootloader**: Limine with direct UKI boot
- **Encryption**: LUKS with Plymouth password dialog
- **Shell**: Kitty + Starship prompt

## Structure

```
romarchy/
├── bin/           # Scripts (launchers, power menu, etc.)
├── config/        # App configs (hypr, waybar, kitty, etc.)
├── default/       # Default configs (limine, plymouth)
├── install/       # Installation scripts
│   ├── helpers/   # Shared functions (check.sh, ui.sh, errors.sh, logging.sh)
│   ├── preflight/ # System checks (guard.sh, disable-mkinitcpio.sh)
│   ├── packs/     # Package installation (01-core, 02-terminal, etc.)
│   ├── config/    # Config copying
│   ├── login/     # Limine + Snapper setup
│   └── post-install/ # Post-install services
└── AGENTS.md
```

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
Installed automatically via `romarchy-ai-install`:
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
romarchy-ai-install

# Install web app manually (via menu)
romarchy-menu → Web Apps → Install Web App
```

## Inspired by

[Omarchy](https://github.com/basecamp/omarchy) - Beautiful, Modern & Opinionated Linux distribution

## License

Personal dotfiles project.
