#!/bin/bash

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"

echo ""
echo -e "\033[1;36m═══ SwayOSD OSD Configuration Setup ═══\033[0m"

# Create swayosd config directory
mkdir -p "$HOME/.config/swayosd"

# Copy config.toml
echo -n "  Creating swayosd config.toml... "
cat > "$HOME/.config/swayosd/config.toml" << 'EOF'
[server]
show_percentage = true
max_volume = 100
style = "~/.config/swayosd/style.css"
EOF
echo -e "\033[32m✓\033[0m"

# Copy style.css (matching user's current setup)
echo -n "  Creating swayosd style.css... "
cat > "$HOME/.config/swayosd/style.css" << 'EOF'
window#osd {
  border-radius: 10px;
  opacity: 0.97;
  border: 2px solid #cba6f7;
  background-color: #000000;
}

window#osd label {
  font-size: 11pt;
  color: #cdd6f4;
}

window#osd image {
  min-width: 20px;
  min-height: 20px;
  color: #89b4fa;
}

window#osd progressbar {
  border-radius: 0;
}

window#osd progress {
  background-color: #cba6f7;
}
EOF
echo -e "\033[32m✓\033[0m"

echo ""
echo -e "\033[32mSwayOSD OSD configuration complete!\033[0m"
