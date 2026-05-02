#!/bin/bash

# Set links for Nautilus action icons (GNOME Files)
sudo ln -snf /usr/share/icons/Adwaita/ symbolic/actions/go-previous-symbolic.svg /usr/share/icons/Yaru/scalable/actions/go-previous-symbolic.svg
sudo ln -snf /usr/share/icons/Adwaita/ symbolic/actions/go-next-symbolic.svg /usr/share/icons/Yaru/scalable/actions/go-next-symbolic.svg

# Setup user theme folder
mkdir -p ~/.config/romarchy/themes

# Set initial theme (catppuccin as requested)
theme-set "catppuccin"
rm -rf ~/.config/chromium/SingletonLock 2>/dev/null || true

# Set specific app links for current theme
mkdir -p ~/.config/btop/themes
ln -snf ~/.config/romarchy/current/theme/btop.theme ~/.config/btop/themes/current.theme

mkdir -p ~/.config/mako
ln -snf ~/.config/romarchy/current/theme/mako.ini ~/.config/mako/config
