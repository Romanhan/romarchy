#!/bin/bash
# Install all base packages from romarchy-base.packages
# Omarchy pattern: mapfile + pkg-add

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
ROMARCHY_INSTALL="$ROMARCHY_DIR/install"

mapfile -t packages < <(grep -v '^#' "$ROMARCHY_INSTALL/packaging/romarchy-base.packages" | grep -v '^$')

if [[ ${#packages[@]} -eq 0 ]]; then
  echo "Error: No packages found in romarchy-base.packages"
  exit 1
fi

echo ""
echo -e "\033[1;34m═══ Base Packages ═══\033[0m"
echo ""
echo "Installing ${#packages[@]} packages..."

pkg-add "${packages[@]}"
