#!/bin/bash
# Post-install scripts (Omarchy pattern: explicit calls)
ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
POST_INSTALL_DIR="$ROMARCHY_DIR/install/post-install"

# Explicit calls like Omarchy
if [[ -f $POST_INSTALL_DIR/01-services.sh ]]; then
  run_logged "$POST_INSTALL_DIR/01-services.sh"
fi

if [[ -f $POST_INSTALL_DIR/02-lazyvim.sh ]]; then
  run_logged "$POST_INSTALL_DIR/02-lazyvim.sh"
fi

if [[ -f $POST_INSTALL_DIR/03-walker-elephant.sh ]]; then
  run_logged "$POST_INSTALL_DIR/03-walker-elephant.sh"
fi

if [[ -f $POST_INSTALL_DIR/04-boot-entries.sh ]]; then
  run_logged "$POST_INSTALL_DIR/04-boot-entries.sh"
fi

if [[ -f $POST_INSTALL_DIR/06-btop.sh ]]; then
  run_logged "$POST_INSTALL_DIR/06-btop.sh"
fi

if [[ -f $POST_INSTALL_DIR/07-theme.sh ]]; then
  run_logged "$POST_INSTALL_DIR/07-theme.sh"
fi
