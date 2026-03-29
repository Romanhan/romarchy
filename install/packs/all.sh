#!/bin/bash
# Run all pack installation scripts

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
PACKS_DIR="$ROMARCHY_DIR/install/packs"

for script in "$PACKS_DIR"/*.sh; do
  if [[ -f "$script" && "$(basename "$script")" != "all.sh" ]]; then
    run_logged "$script"
  fi
done
