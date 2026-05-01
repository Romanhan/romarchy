#!/bin/bash
# Run all packaging scripts (Omarchy pattern: explicit run_logged calls)

ROMARCHY_INSTALL="${ROMARCHY_INSTALL:-$ROMARCHY_DIR/install}"

run_logged "$ROMARCHY_INSTALL/packaging/base.sh"
run_logged "$ROMARCHY_INSTALL/packaging/fonts.sh"
run_logged "$ROMARCHY_INSTALL/packaging/icons.sh"
run_logged "$ROMARCHY_INSTALL/packaging/nvim.sh"
run_logged "$ROMARCHY_INSTALL/packaging/screenshot.sh"
run_logged "$ROMARCHY_INSTALL/packaging/optional.sh"
