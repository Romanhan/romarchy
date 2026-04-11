#!/bin/bash

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"

echo ""
echo -e "\033[1;36m═══ Theme Setup ═══\033[0m"

echo ""
echo "Setting up waybar config:"
mkdir -p "$HOME/.config/waybar"

echo -n "  config.jsonc... "
if [[ ! -f "$HOME/.config/waybar/config.jsonc" ]]; then
  cp "$ROMARCHY_DIR/config/waybar/config.jsonc" "$HOME/.config/waybar/config.jsonc"
fi
echo -e "\033[32m✓\033[0m"

echo -n "  style.css... "
if [[ ! -f "$HOME/.config/waybar/style.css" ]]; then
  cp "$ROMARCHY_DIR/config/waybar/style.css" "$HOME/.config/waybar/style.css"
fi
echo -e "\033[32m✓\033[0m"

echo -n "  font.css... "
if [[ ! -f "$HOME/.config/waybar/font.css" ]]; then
  cp "$ROMARCHY_DIR/config/waybar/font.css" "$HOME/.config/waybar/font.css"
fi
echo -e "\033[32m✓\033[0m"

echo ""
echo "Setting up swayosd config:"
mkdir -p "$HOME/.config/swayosd"

echo -n "  config.toml... "
cat > "$HOME/.config/swayosd/config.toml" << 'EOF'
[server]
show_percentage = true
max_volume = 100
style = "~/.config/swayosd/style.css"
EOF
echo -e "\033[32m✓\033[0m"

echo -n "  style.css... "
if [[ ! -f "$HOME/.config/swayosd/style.css" ]]; then
  cp "$ROMARCHY_DIR/config/swayosd/style.css" "$HOME/.config/swayosd/style.css"
fi
echo -e "\033[32m✓\033[0m"

echo ""
echo "Setting up theme structure:"
echo -n "  romarchy symlink... "
if [[ ! -L "$HOME/.config/romarchy" ]]; then
  ln -sf "$ROMARCHY_DIR" "$HOME/.config/romarchy"
fi
echo -e "\033[32m✓\033[0m"

echo -n "  current theme directory... "
mkdir -p "$HOME/.config/romarchy/current/theme"
echo -e "\033[32m✓\033[0m"

echo -n "  btop themes directory... "
mkdir -p "$HOME/.config/btop/themes"
echo -e "\033[32m✓\033[0m"

echo ""
echo "Applying default theme:"
CURRENT_THEME=$(cat "$ROMARCHY_DIR/.current-theme" 2>/dev/null || echo "catppuccin-mocha-black")
echo -n "  $CURRENT_THEME... "
if "$ROMARCHY_DIR/bin/theme-set" "$CURRENT_THEME" >/dev/null 2>&1; then
  echo -e "\033[32m✓\033[0m"
else
  echo -e "\033[33m!\033[0m (theme generation failed, using defaults)"
fi

echo ""
echo -e "\033[32mTheme setup complete!\033[0m"