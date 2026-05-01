#!/bin/bash
# Copy bundled icons to applications/icons directory
# Omarchy pattern: copy from default/icons

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
source "$ROMARCHY_DIR/install/helpers/ui.sh"

header "Icons"

ICON_DIR="$HOME/.local/share/applications/icons"
mkdir -p "$ICON_DIR"

if [[ -d $ROMARCHY_DIR/applications/icons ]]; then
  cp "$ROMARCHY_DIR/applications/icons/"*.png "$ICON_DIR/" 2>/dev/null && success "Icons copied"
else
  info "No icons to copy (applications/icons/ not found)"
fi
