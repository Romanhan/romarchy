#!/bin/bash

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"

echo ""
echo -e "\033[1;36m═══ Btop & Launcher Setup ═══\033[0m"

SCRIPTS=(
  "launch-or-focus"
  "launch-or-focus-tui"
  "launch-tui"
  "restart-waybar"
  "restart-app"
  "restart-btop"
)

echo ""
echo "Checking launcher scripts:"
for script in "${SCRIPTS[@]}"; do
  echo -n "  $script... "
  if [[ -x "$ROMARCHY_DIR/bin/$script" ]]; then
    echo -e "\033[32m✓\033[0m"
  else
    echo -e "\033[33m!\033[0m (not found, skipping)"
  fi
done

echo ""
echo "Updating waybar config:"
WAYBAR_CONFIG="$HOME/.config/waybar/config.jsonc"
if [[ -f "$WAYBAR_CONFIG" ]]; then
  if grep -q 'omarchy-launch-or-focus-tui btop' "$WAYBAR_CONFIG" 2>/dev/null; then
    sed -i 's/omarchy-launch-or-focus-tui btop/launch-or-focus-tui btop/g' "$WAYBAR_CONFIG"
    echo -e "  Fixed omarchy references... \033[32m✓\033[0m"
  fi
  if grep -q '\$HOME/.local/share/romarchy/bin/launch-or-focus-tui btop' "$WAYBAR_CONFIG" 2>/dev/null; then
    sed -i 's/\$HOME\.local/share/romarchy/bin\/launch-or-focus-tui btop/launch-or-focus-tui btop/g' "$WAYBAR_CONFIG"
    echo -e "  Removed hardcoded paths... \033[32m✓\033[0m"
  fi
  if ! grep -q 'on-click.*launch-or-focus-tui btop' "$WAYBAR_CONFIG" 2>/dev/null; then
    sed -i 's/"format": "󰍛"/"format": "󰍛",\n    "on-click": "launch-or-focus-tui btop"/g' "$WAYBAR_CONFIG"
    echo -e "  Added btop click handler... \033[32m✓\033[0m"
  fi
else
  echo -e "  \033[33m!\033[0m (waybar config not found)"
fi

echo ""
echo "Updating Hyprland bindings:"
BINDINGS_CONF="$ROMARCHY_DIR/config/hypr/bindings.conf"
if [[ -f "$BINDINGS_CONF" ]]; then
  if grep -q '\$HOME/.local/share/romarchy/bin/launch-or-focus-tui btop' "$BINDINGS_CONF" 2>/dev/null; then
    sed -i 's|\$HOME/.local/share/romarchy/bin/launch-or-focus-tui btop|launch-or-focus-tui btop|g' "$BINDINGS_CONF"
    echo -e "  Fixed btop keybind path... \033[32m✓\033[0m"
  fi
  if grep -q '\$HOME/.local/share/romarchy/bin/restart-waybar' "$BINDINGS_CONF" 2>/dev/null; then
    sed -i 's|\$HOME/.local/share/romarchy/bin/restart-waybar|restart-waybar|g' "$BINDINGS_CONF"
    echo -e "  Fixed waybar restart keybind path... \033[32m✓\033[0m"
  fi
  if ! grep -q 'launch-or-focus-tui btop' "$BINDINGS_CONF" 2>/dev/null; then
    sed -i '/^# System monitors$/a bindd = CTRL ALT, Delete, Activity monitor, exec, launch-or-focus-tui btop' "$BINDINGS_CONF"
    echo -e "  Added btop keybind... \033[32m✓\033[0m"
  fi
  if ! grep -q 'restart-waybar' "$BINDINGS_CONF" 2>/dev/null; then
    sed -i '/^# System$/a bindd = SUPER CTRL, W, Restart waybar, exec, restart-waybar' "$BINDINGS_CONF"
    echo -e "  Added waybar restart keybind... \033[32m✓\033[0m"
  fi
else
  echo -e "  \033[33m!\033[0m (bindings.conf not found)"
fi

echo ""
echo "Reloading configurations:"
if pgrep -x Hyprland > /dev/null; then
  hyprctl reload 2>/dev/null
  echo -e "  Hyprland... \033[32m✓\033[0m"
else
  echo -e "  Hyprland... \033[33m~\033[0m (not running)"
fi

if pgrep -x waybar > /dev/null; then
  pkill -HUP waybar 2>/dev/null
  echo -e "  Waybar... \033[32m✓\033[0m"
else
  echo -e "  Waybar... \033[33m~\033[0m (not running)"
fi

echo ""
echo -e "\033[32mDone!\033[0m"