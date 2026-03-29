#!/bin/bash
# Disable mkinitcpio hooks during installation (Omarchy's speed optimization)

info "Disabling mkinitcpio hooks during installation..."

if [[ -f /usr/share/libalpm/hooks/90-mkinitcpio-install.hook ]]; then
  sudo mv /usr/share/libalpm/hooks/90-mkinitcpio-install.hook \
         /usr/share/libalpm/hooks/90-mkinitcpio-install.hook.disabled 2>/dev/null || true
fi

if [[ -f /usr/share/libalpm/hooks/60-mkinitcpio-remove.hook ]]; then
  sudo mv /usr/share/libalpm/hooks/60-mkinitcpio-remove.hook \
         /usr/share/libalpm/hooks/60-mkinitcpio-remove.hook.disabled 2>/dev/null || true
fi

success "mkinitcpio hooks disabled"
