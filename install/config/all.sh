#!/bin/bash
# Copy Romarchy configs to ~/.config/

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
source "$ROMARCHY_DIR/install/helpers/ui.sh"

header "Copying Romarchy configs"

mkdir -p ~/.config
cp -R "$ROMARCHY_DIR/config/"* ~/.config/

for script in "$ROMARCHY_DIR/install/config/"*.sh; do
  if [[ -f "$script" && "$(basename "$script")" != "all.sh" ]]; then
    bash "$script"
  fi
done

success "Configs copied"
