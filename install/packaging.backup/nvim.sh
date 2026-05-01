#!/bin/bash
# Neovim setup
# Neovim is installed via romarchy-base.packages
# Add any custom setup here (lazyvim, etc.) if needed

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
source "$ROMARCHY_DIR/install/helpers/ui.sh"

header "Neovim"

if command -v nvim &>/dev/null; then
  success "Neovim installed"
else
  warn "Neovim not found"
fi
