#!/bin/bash
ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
LOGIN_DIR="$ROMARCHY_DIR/install/login"

for script in "$LOGIN_DIR"/*.sh; do
  if [[ -f "$script" && "$(basename "$script")" != "all.sh" ]]; then
    bash "$script"
  fi
done
