#!/bin/bash
# Preflight checks (Omarchy-style)

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
PREFLIGHT_DIR="$ROMARCHY_DIR/install/preflight"

source "$ROMARCHY_DIR/install/helpers/ui.sh"

for script in "$PREFLIGHT_DIR"/*.sh; do
  if [[ -f "$script" && "$(basename "$script")" != "all.sh" ]]; then
    source "$script"
  fi
done
