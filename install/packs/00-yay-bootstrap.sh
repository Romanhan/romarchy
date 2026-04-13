#!/bin/bash

# Bootstrap yay AUR helper BEFORE other packages
# This must run FIRST before any other pack that might need yay

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"

echo ""
echo -e "\033[1;34m═══ Yay Bootstrap ═══\033[0m"
echo ""

# Check if yay is already installed
if command -v yay &>/dev/null; then
  echo -e "  \033[32m✓\033[0m yay already installed"
  exit 0
fi

echo "  Installing git and base-devel..."
sudo pacman -S --noconfirm git base-devel

echo "  Cloning and building yay from AUR..."
cd /tmp
rm -rf yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd -
rm -rf /tmp/yay

# Verify yay is installed
if command -v yay &>/dev/null; then
  echo -e "  \033[32m✓\033[0m yay installed successfully"
else
  echo -e "  \033[31m✗\033[0m yay installation failed"
  exit 1
fi