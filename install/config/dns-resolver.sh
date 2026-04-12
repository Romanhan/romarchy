#!/bin/bash

echo "Setting up DNS resolver..."

# Check if already configured
if [[ -L /etc/resolv.conf ]]; then
  current_target=$(readlink -f /etc/resolv.conf 2>/dev/null)
  if [[ $current_target == "/run/systemd/resolve/stub-resolv.conf" ]]; then
    echo "DNS resolver already configured."
    exit 0
  fi
fi

# Enable systemd-resolved first
echo "Enabling systemd-resolved..."
sudo systemctl enable --now systemd-resolved

# Backup existing resolv.conf if needed
if [[ -f /etc/resolv.conf ]] && [[ ! -L /etc/resolv.conf ]]; then
  backup_file="/etc/resolv.conf.bak.$(date +%s)"
  echo "Backing up /etc/resolv.conf to $backup_file"
  sudo cp -f /etc/resolv.conf "$backup_file"
fi

# Create symlink
echo "Symlinking /etc/resolv.conf to systemd-resolved..."
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

echo "DNS resolver configured."