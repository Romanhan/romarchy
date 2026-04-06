#!/bin/bash

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"

echo ""
echo -e "\033[1;36m═══ Essential Services Setup ═══\033[0m"

setup_symlinks() {
  echo ""
  echo "Creating symlinks:"
  local configs=("hypr" "waybar" "kitty" "walker" "elephant" "uwsm")
  
  for config in "${configs[@]}"; do
    local source="$ROMARCHY_DIR/config/$config"
    local target="$HOME/.config/$config"
    
    echo -n "  $config... "
    
    if [[ -L "$target" ]]; then
      echo -e "\033[33m~\033[0m (already linked)"
    elif [[ -e "$target" ]]; then
      echo -e "\033[33m!\033[0m (exists, skipping)"
    else
      ln -sf "$source" "$target"
      echo -e "\033[32m✓\033[0m"
    fi
  done
  
  if [[ ! -L "$HOME/.config/romarchy" ]]; then
    echo -n "  romarchy... "
    ln -sf "$ROMARCHY_DIR" "$HOME/.config/romarchy"
    echo -e "\033[32m✓\033[0m"
  fi

  echo ""
  echo "Setting up mako theme:"
  echo -n "  mako theme.ini... "
  local current_theme=$(cat "$ROMARCHY_DIR/.current-theme" 2>/dev/null || echo "catppuccin-mocha-black")
  if [[ -f "$ROMARCHY_DIR/themes/$current_theme/mako.ini" ]]; then
    ln -sf "$ROMARCHY_DIR/themes/$current_theme/mako.ini" "$HOME/.config/mako/theme.ini"
    echo -e "\033[32m✓\033[0m ($current_theme)"
  else
    echo -e "\033[33m!\033[0m (no mako.ini for $current_theme)"
  fi
  
  echo ""
  echo "Setting up bashrc:"
  echo -n "  Romarchy bash config... "
  if grep -q "romarchy/default/bash/rc" "$HOME/.bashrc" 2>/dev/null; then
    echo -e "\033[33m~\033[0m (already set)"
  else
    cat > "$HOME/.bashrc" << 'BASHRC'
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Romarchy bash configuration
source ~/.local/share/romarchy/default/bash/rc
BASHRC
    echo -e "\033[32m✓\033[0m"
  fi
}

setup_symlinks

enable_service() {
  local service="$1"
  local description="$2"
  
  echo -n "  $description... "
  
  if systemctl is-enabled "$service" &>/dev/null; then
    echo -e "\033[33m~\033[0m (already enabled)"
  else
    sudo systemctl enable "$service" 2>/dev/null
    if systemctl is-enabled "$service" &>/dev/null; then
      echo -e "\033[32m✓\033[0m"
    else
      echo -e "\033[31m✗\033[0m (failed)"
    fi
  fi
}

start_service() {
  local service="$1"
  local description="$2"
  
  echo -n "  $description... "
  
  if systemctl is-active "$service" &>/dev/null; then
    echo -e "\033[33m~\033[0m (already running)"
  else
    sudo systemctl start "$service" 2>/dev/null
    if systemctl is-active "$service" &>/dev/null; then
      echo -e "\033[32m✓\033[0m"
    else
      echo -e "\033[31m✗\033[0m (failed)"
    fi
  fi
}

echo ""
echo "System services:"
enable_service "iwd" "WiFi (iwd)"
start_service "iwd" "WiFi (iwd)"
enable_service "bluetooth" "Bluetooth"
start_service "bluetooth" "Bluetooth"

echo ""
echo "User services:"
echo -n "  Elephant (walker backend)... "
if pgrep -x elephant > /dev/null; then
  echo -e "\033[32m✓\033[0m (running)"
else
  systemctl --user start elephant.service 2>/dev/null || setsid uwsm-app -- elephant &>/dev/null &
  sleep 1
  if pgrep -x elephant > /dev/null; then
    echo -e "\033[32m✓\033[0m (started)"
  else
    echo -e "\033[33m!\033[0m (failed to start)"
  fi
fi

echo ""
echo -n "  Reloading Hyprland... "
hyprctl reload >/dev/null 2>&1
if pgrep -x Hyprland > /dev/null; then
  echo -e "\033[32m✓\033[0m"
else
  echo -e "\033[33m~\033[0m (reload on next login)"
fi

echo ""
echo -e "\033[32mDone!\033[0m"
