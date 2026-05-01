#!/bin/bash
# Screenshot setup
# Uses cmd-screenshot (copied from Omarchy)
# Packages installed via romarchy-base.packages: grim, slurp, satty, imv, wl-clipboard

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
source "$ROMARCHY_DIR/install/helpers/ui.sh"

header "Screenshot"

# Verify cmd-screenshot exists
if [[ ! -f $ROMARCHY_DIR/bin/cmd-screenshot ]]; then
  warn "cmd-screenshot not found, copying..."
  cp /home/romanhan/omarchy/bin/omarchy-cmd-screenshot "$ROMARCHY_DIR/bin/cmd-screenshot"
  chmod +x "$ROMARCHY_DIR/bin/cmd-screenshot"
fi

# Create screenshots directory
mkdir -p "$HOME/Pictures/Screenshots"

info "Screenshot: Use 'cmd-screenshot' or PRINT key"
info "Editor: satty (default)"
