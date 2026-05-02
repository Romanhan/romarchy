#!/bin/bash
# Romarchy Install - Run All Config Scripts
# Similar to omarchy's all.sh

ROMARCHY_PATH="${ROMARCHY_PATH:-$HOME/.local/share/romarchy}"
ROMARCHY_INSTALL="$ROMARCHY_PATH/install"

run_logged() {
  echo "Running: $1"
  bash "$ROMARCHY_INSTALL/$1" "$@"
}

# Core config
run_logged config/theme.sh
run_logged config/user-dirs.sh

# Optional configs (uncomment as needed)
# run_logged config/git.sh
# run_logged config/gpg.sh
# run_logged config/docker.sh
# run_logged config/hardware/network.sh
