#!/bin/bash
# Copy Romarchy configs to ~/.config/

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
source "$ROMARCHY_DIR/install/helpers/ui.sh"

header "Copying Romarchy configs"

mkdir -p ~/.config
cp -R "$ROMARCHY_DIR/config/"* ~/.config/

success "Configs copied"
