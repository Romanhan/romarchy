#!/bin/bash

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
source "$ROMARCHY_DIR/install/helpers/check.sh"
source "$ROMARCHY_DIR/install/helpers/ui.sh"

check_and_install "Utils" \
  wl-clipboard \
  grim \
  slurp \
  mako \
  brightnessctl \
  pamixer \
  playerctl \
  bluetui \
  yazi \
  ffmpeg \
  p7zip \
  jq \
  poppler \
  fzf \
  zoxide \
  resvg \
  imagemagick \
  trash-cli \
  gum \
  yaru-icon-theme \
  xdg-desktop-portal-gtk \
  xdg-desktop-portal-hyprland \
  btop
