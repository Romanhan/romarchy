#!/bin/bash
# Run all config scripts (Omarchy pattern: explicit calls)
ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
source "$ROMARCHY_DIR/install/helpers/ui.sh"

# Base config copy (Omarchy pattern)
run_logged "$ROMARCHY_DIR/install/config/config.sh"

# Theme setup
run_logged "$ROMARCHY_DIR/install/config/theme.sh"

# Optional configs (uncomment as needed)
# run_logged "$ROMARCHY_DIR/install/config/git.sh"
# run_logged "$ROMARCHY_DIR/install/config/gpg.sh"
# run_logged "$ROMARCHY_DIR/install/config/user-dirs.sh"

# Hardware configs
if [[ -d $ROMARCHY_DIR/install/config/hardware ]]; then
  for script in "$ROMARCHY_DIR/install/config/hardware/"*.sh; do
    [[ -f "$script" ]] && run_logged "$script"
  done
fi

success "All configs applied"
