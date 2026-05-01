#!/bin/bash
# Copy all configs from romarchy to ~/.config (Omarchy pattern)
ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
source "$ROMARCHY_DIR/install/helpers/ui.sh"

header "Copying Romarchy configs"

# Copy config/ to ~/.config/
if [[ -d $ROMARCHY_DIR/config ]]; then
  mkdir -p ~/.config
  cp -R "$ROMARCHY_DIR/config/"* ~/.config/ 2>/dev/null || true
fi

# Copy default/ to home (bashrc, etc.)
if [[ -d $ROMARCHY_DIR/default ]]; then
  [[ -f $ROMARCHY_DIR/default/bashrc ]] && cp "$ROMARCHY_DIR/default/bashrc" ~/.bashrc
  echo '[[ -f ~/.bashrc ]] && . ~/.bashrc' | tee ~/.bash_profile >/dev/null
fi

success "Configs copied"
