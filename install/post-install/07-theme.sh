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
echo -e "  \033[32m✓\033[0m"

echo -n "  style.css... "
if [[ ! -f "$HOME/.config/waybar/style.css" ]]; then
  cp "$ROMARCHY_DIR/config/waybar/style.css" "$HOME/.config/waybar/style.css"
fi
echo -e "  \033[32m✓\033[0m"

echo -n "  font.css... "
if [[ ! -f "$HOME/.config/waybar/font.css" ]]; then
  cp "$ROMARCHY_DIR/config/waybar/font.css" "$HOME/.config/waybar/font.css"
fi
echo -e "  \033[32m✓\033[0m"

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
echo -e "  \033[32m✓\033[0m"

echo -n "  style.css... "
if [[ ! -f "$HOME/.config/swayosd/style.css" ]]; then
  cp "$ROMARCHY_DIR/config/swayosd/style.css" "$HOME/.config/swayosd/style.css"
fi
echo -e "  \033[32m✓\033[0m"

echo ""
echo "Setting up theme structure:"
echo -n "  romarchy config directories... "
mkdir -p "$HOME/.config/romarchy/themes"
mkdir -p "$HOME/.config/romarchy/backgrounds"
mkdir -p "$HOME/.config/romarchy/current/theme"
mkdir -p "$HOME/.config/romarchy/current/theme/backgrounds"
echo -e "  \033[32m✓\033[0m"

echo -n "  walker themes directory... "
mkdir -p "$HOME/.config/walker/themes/current"
echo -e "  \033[32m✓\033[0m"

echo -n "  applying initial theme... "
CURRENT_THEME=$(cat "$ROMARCHY_DIR/.current-theme" 2>/dev/null || echo "catppuccin-mocha-black")
if [[ -d "$ROMARCHY_DIR/themes/$CURRENT_THEME" ]]; then
  rm -rf "$HOME/.config/romarchy/current/next-theme"
  mkdir -p "$HOME/.config/romarchy/current/next-theme"
  cp -r "$ROMARCHY_DIR/themes/$CURRENT_THEME/"* "$HOME/.config/romarchy/current/next-theme/" 2>/dev/null
  rm -rf "$HOME/.config/romarchy/current/theme"
  mv "$HOME/.config/romarchy/current/next-theme" "$HOME/.config/romarchy/current/theme"
fi
echo -e "  \033[32m✓\033[0m"

echo -n "  btop themes directory... "
mkdir -p "$HOME/.config/btop/themes"
echo -e "  \033[32m✓\033[0m"

echo -n "  btop current symlink... "
ln -sf "$HOME/.config/romarchy/current/theme/btop.theme" "$HOME/.config/btop/themes/current.theme" 2>/dev/null
echo -e "  \033[32m✓\033[0m"

echo -n "  mako config symlink... "
mkdir -p "$HOME/.config/mako"
rm -f "$HOME/.config/mako/config"
if [[ -f "$HOME/.config/romarchy/current/theme/mako.ini" ]]; then
  ln -sf "$HOME/.config/romarchy/current/theme/mako.ini" "$HOME/.config/mako/config"
fi
echo -e "  \033[32m✓\033[0m"

echo -n "  btop config... "
if [[ -f "$HOME/.config/btop/btop.conf" ]]; then
  sed -i 's/^color_theme = .*/color_theme = "current"/' "$HOME/.config/btop/btop.conf"
else
  mkdir -p "$HOME/.config/btop"
  cat > "$HOME/.config/btop/btop.conf" << 'EOF'
#? Config file for btop

#* Name of a btop++/bpytop/bashtop formatted ".theme" file, "Default" and "TTY" for builtin themes.
#* Themes should be placed in "../share/btop/themes" relative to binary or "$HOME/.config/btop/themes"
color_theme = "current"

#* If the theme set background should be shown, set to False if you want terminal background transparency.
theme_background = True

#* Sets if 24-bit truecolor should be used, will convert 24-bit colors to 256 color (6x6x6 color cube) if false.
truecolor = True
EOF
fi
echo -e "  \033[32m✓\033[0m"

echo ""
echo "Applying default theme:"
CURRENT_THEME=$(cat "$ROMARCHY_DIR/.current-theme" 2>/dev/null || echo "catppuccin-mocha-black")
echo -n "  $CURRENT_THEME... "
if "$ROMARCHY_DIR/bin/theme-set" "$CURRENT_THEME" >/dev/null 2>&1; then
  echo -e "  \033[32m✓\033[0m"
else
  echo -e "  \033[33m!\033[0m (theme generation failed, using defaults)"
fi

echo ""
echo -e "\033[32mTheme setup complete!\033[0m"