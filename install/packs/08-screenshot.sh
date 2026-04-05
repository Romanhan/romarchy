#!/bin/bash

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
source "$ROMARCHY_DIR/install/helpers/check.sh"
source "$ROMARCHY_DIR/install/helpers/ui.sh"

check_and_install "Screenshot" \
  grim \
  slurp \
  satty \
  imv \
  mako

# Copy screenshot scripts
mkdir -p "$HOME/.local/share/romarchy/bin"
cp -f "$ROMARCHY_DIR/bin/romarchy-cmd-screenshot" "$HOME/.local/share/romarchy/bin/"
cp -f "$ROMARCHY_DIR/bin/romarchy-cmd-screenshot-edit" "$HOME/.local/share/romarchy/bin/"
chmod +x "$HOME/.local/share/romarchy/bin/romarchy-cmd-screenshot"
chmod +x "$HOME/.local/share/romarchy/bin/romarchy-cmd-screenshot-edit"

# Copy default configs
mkdir -p "$HOME/.config/satty"
mkdir -p "$HOME/.config/mako"
mkdir -p "$HOME/.config/environment.d"
cp -f "$ROMARCHY_DIR/config/satty/config.toml" "$HOME/.config/satty/config.toml"
cp -f "$ROMARCHY_DIR/config/mako/config" "$HOME/.config/mako/config"
cp -f "$ROMARCHY_DIR/config/mako/core.ini" "$HOME/.config/mako/core.ini"
cp -f "$ROMARCHY_DIR/config/environment.d/romarchy.conf" "$HOME/.config/environment.d/romarchy.conf"

# Set up mako theme symlink
CURRENT_THEME=$(cat "$ROMARCHY_DIR/.current-theme" 2>/dev/null || echo "catppuccin-mocha-black")
if [[ -f "$ROMARCHY_DIR/themes/$CURRENT_THEME/mako.ini" ]]; then
  ln -sf "$ROMARCHY_DIR/themes/$CURRENT_THEME/mako.ini" "$HOME/.config/mako/theme.ini"
fi

# Create screenshots directory
mkdir -p "$HOME/Pictures/Screenshots"

# Add screenshot bindings to Hyprland if not present
HYPR_BINDINGS="$HOME/.config/hypr/bindings.conf"
if [[ -f $HYPR_BINDINGS ]]; then
  if ! grep -q "romarchy-cmd-screenshot" "$HYPR_BINDINGS"; then
    sed -i '/^# Mouse$/i # Screenshot\nbindd = , PRINT, Screenshot, exec, romarchy-cmd-screenshot\nbindd = SHIFT, PRINT, Screenshot fullscreen, exec, romarchy-cmd-screenshot fullscreen\nbindd = SUPER ALT, comma, Edit last screenshot, exec, romarchy-cmd-screenshot-edit\n' "$HYPR_BINDINGS"
  fi
fi

# Reload mako to pick up new config
systemctl --user restart mako 2>/dev/null

# Set up xdg-image-viewers.list for default image handling
if [[ -f "$ROMARCHY_DIR/config/xdg-image-viewers.list" ]]; then
  mkdir -p "$HOME/.config"
  cp -f "$ROMARCHY_DIR/config/xdg-image-viewers.list" "$HOME/.config/xdg-image-viewers.list"

  # Set first available image viewer as default
  while read -r viewer; do
    if command -v "$viewer" &>/dev/null; then
      viewer_desktop="${viewer}.desktop"
      xdg-mime default "$viewer_desktop" image/jpeg 2>/dev/null || true
      xdg-mime default "$viewer_desktop" image/png 2>/dev/null || true
      xdg-mime default "$viewer_desktop" image/gif 2>/dev/null || true
      xdg-mime default "$viewer_desktop" image/webp 2>/dev/null || true
      xdg-mime default "$viewer_desktop" image/bmp 2>/dev/null || true
      xdg-mime default "$viewer_desktop" image/svg+xml 2>/dev/null || true
      break
    fi
  done < "$HOME/.config/xdg-image-viewers.list"
fi
