#!/bin/bash

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
source "$ROMARCHY_DIR/install/helpers/ui.sh"

header "Setting up bash config"

mkdir -p "$HOME/.local/share/romarchy/default/bash"
cp -R "$ROMARCHY_DIR/default/bash/"* "$HOME/.local/share/romarchy/default/bash/"

cp "$ROMARCHY_DIR/default/bashrc" ~/.bashrc

success "Bash config deployed"