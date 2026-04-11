#!/bin/bash

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"

echo ""
echo -e "\033[1;36m═══ SwayOSD OSD Configuration Setup ═══\033[0m"

mkdir -p "$HOME/.config/swayosd"

echo -n "  config.toml... "
cat > "$HOME/.config/swayosd/config.toml" << 'EOF'
[server]
show_percentage = true
max_volume = 100
style = "~/.config/swayosd/style.css"
EOF
echo -e "\033[32m✓\033[0m"

echo -n "  style.css (theme-aware)... "
cat > "$HOME/.config/swayosd/style.css" << 'EOF'
@import "../romarchy/current/theme/swayosd.css";

window#osd {
  border-radius: 10px;
  opacity: 0.97;
  border: 2px solid @accent;
  background-color: @background;
}

window#osd label {
  font-size: 11pt;
  color: @foreground;
}

window#osd image {
  min-width: 20px;
  min-height: 20px;
  color: @accent;
}

window#osd progressbar {
  border-radius: 0;
}

window#osd progress {
  background-color: @accent;
}
EOF
echo -e "\033[32m✓\033[0m"

echo ""
echo -e "\033[32mSwayOSD OSD configuration complete!\033[0m"
