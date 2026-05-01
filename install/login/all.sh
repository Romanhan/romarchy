#!/bin/bash
# Login/Boot setup (Omarchy pattern: explicit calls)
ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
LOGIN_DIR="$ROMARCHY_DIR/install/login"

# Limine + Snapper setup (if limine is installed)
if command -v limine &>/dev/null; then
  run_logged "$LOGIN_DIR/limine-snapper.sh"
fi
