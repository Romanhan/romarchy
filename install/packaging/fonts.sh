#!/bin/bash
# Fonts are installed via romarchy-base.packages
# This script verifies installation

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
source "$ROMARCHY_DIR/install/helpers/ui.sh"

header "Fonts"

info "Cascadia Code Nerd: ttf-cascadia-code-nerd"
info "JetBrains Mono Nerd: ttf-jetbrains-mono-nerd"

# Rebuild font cache
fc-cache -fv &>/dev/null && success "Font cache updated"
