#!/bin/bash

echo "Setting up WiFi services..."

echo "Enabling iwd (WiFi connection)..."
sudo systemctl enable --now iwd

echo "Enabling NetworkManager (DHCP + DNS)..."
sudo systemctl enable --now NetworkManager

echo "Enabling systemd-resolved (DNS resolution)..."
sudo systemctl enable --now systemd-resolved

echo ""
echo "WiFi services enabled:"
echo "  - iwd (WiFi connection)"
echo "  - NetworkManager (DHCP + DNS)"
echo "  - systemd-resolved (DNS)"
echo ""
echo "WiFi setup complete."