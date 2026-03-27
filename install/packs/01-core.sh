#!/bin/bash

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
source "$ROMARCHY_DIR/install/helpers/check.sh"
source "$ROMARCHY_DIR/install/helpers/ui.sh"

check_and_install "Core" \
  hyprland \
  waybar \
  hyprlock \
  hypridle \
  hyprpicker \
  hyprsunset \
  uwsm \
  brave-bin \
  swaybg \
  nautilus \
  visual-studio-code-bin \
  pipewire \
  pipewire-alsa \
  pipewire-pulse \
  wireplumber
