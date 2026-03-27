#!/bin/bash
# Copy Romarchy configs to ~/.config/

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"

echo ""
echo "=== Copying Romarchy configs ==="

mkdir -p ~/.config
cp -R "$ROMARCHY_DIR/config/"* ~/.config/

echo "✓ Configs copied"
