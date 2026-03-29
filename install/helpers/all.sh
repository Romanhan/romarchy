#!/bin/bash
# Load all helpers

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
HELPERS_DIR="$ROMARCHY_DIR/install/helpers"

source "$HELPERS_DIR/check.sh"
source "$HELPERS_DIR/ui.sh"
source "$HELPERS_DIR/errors.sh"
source "$HELPERS_DIR/logging.sh"
