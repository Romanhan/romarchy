#!/bin/bash
# Walker and Elephant setup (like omarchy)

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"

echo ""
echo -e "\033[1;36m═══ Walker & Elephant Setup ═══\033[0m"

# Ensure Walker service is started automatically on boot
mkdir -p ~/.config/autostart/
cp "$ROMARCHY_DIR/default/walker/walker.desktop" ~/.config/autostart/ 2>/dev/null || true

# And is restarted if it crashes or is killed
mkdir -p ~/.config/systemd/user/app-walker@autostart.service.d/
cp "$ROMARCHY_DIR/default/walker/restart.conf" ~/.config/systemd/user/app-walker@autostart.service.d/restart.conf 2>/dev/null || true

# Create pacman hook to restart walker after updates (requires sudo)
if [[ -d /etc/pacman.d/hooks ]]; then
  sudo tee /etc/pacman.d/hooks/walker-restart.hook > /dev/null << EOF
[Trigger]
Type = Package
Operation = Upgrade
Target = walker
Target = walker-debug
Target = elephant*

[Action]
Description = Restarting Walker services after system update
When = PostTransaction
Exec = $ROMARCHY_DIR/bin/romarchy-restart-walker
EOF
  echo -e "  \033[32m✓\033[0m Pacman hook created"
fi

# Link the elephant menu scripts
mkdir -p ~/.config/elephant/menus
ln -snf "$ROMARCHY_DIR/config/elephant/menus/romarchy_background_selector.lua" ~/.config/elephant/menus/romarchy_background_selector.lua
echo -e "  \033[32m✓\033[0m Elephant menus linked"

# Link all elephant providers
echo ""
echo -e "\033[1;34m═══ Linking Elephant Providers ═══\033[0m"
mkdir -p ~/.config/elephant/providers
if [[ -d /usr/lib/elephant/ ]]; then
  for provider in /usr/lib/elephant/*.so; do
    if [[ -f "$provider" ]]; then
      name=$(basename "$provider")
      if [[ ! -L ~/.config/elephant/providers/"$name" ]]; then
        ln -sf "$provider" ~/.config/elephant/providers/"$name"
        echo -e "  \033[32m✓\033[0m $name"
      else
        echo -e "  \033[33m~\033[0m $name (already linked)"
      fi
    fi
  done
else
  echo -e "  \033[33m!\033[0m Elephant providers not found at /usr/lib/elephant/"
fi

# Create theme symlink structure
echo ""
echo -e "\033[1;34m═══ Theme Structure Setup ═══\033[0m"
mkdir -p ~/.config/romarchy/current/theme

# Get current theme name
CURRENT_THEME=$(cat "$ROMARCHY_DIR/.current-theme" 2>/dev/null || echo "catppuccin-mocha-black")
if [[ -d "$ROMARCHY_DIR/themes/$CURRENT_THEME" ]]; then
  ln -snf "$ROMARCHY_DIR/themes/$CURRENT_THEME" ~/.config/romarchy/current/theme
  echo -e "  \033[32m✓\033[0m Theme symlink: $CURRENT_THEME"
fi

# Create backgrounds directory
mkdir -p ~/.config/romarchy/backgrounds/"$CURRENT_THEME"
echo -e "  \033[32m✓\033[0m Backgrounds directory created"

echo ""
echo -e "\033[32m✓ Walker & Elephant setup complete!\033[0m"
