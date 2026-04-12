#!/bin/bash

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
source "$ROMARCHY_DIR/bin/battery-present"

if ! battery-present; then
  echo "No battery detected, skipping WiFi power save rules."
  exit 0
fi

echo "Setting up WiFi power save rules for laptop..."

cat <<EOF | sudo tee /etc/udev/rules.d/99-wifi-powersave.rules
SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="0", RUN+="$HOME/.local/share/romarchy/bin/wifi-powersave on"
SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="1", RUN+="$HOME/.local/share/romarchy/bin/wifi-powersave off"
EOF

sudo udevadm control --reload
sudo udevadm trigger --subsystem-match=power_supply

echo "WiFi power save rules installed."