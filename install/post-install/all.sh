#!/bin/bash

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
INSTALL_DIR="$ROMARCHY_DIR/install/post-install"

for script in "$INSTALL_DIR"/*.sh; do
  if [[ -f "$script" && "$(basename "$script")" != "all.sh" ]]; then
    bash "$script"
  fi
done
