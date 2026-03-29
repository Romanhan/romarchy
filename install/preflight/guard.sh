#!/bin/bash
# System compatibility checks (Omarchy-style)

abort() {
  error "Romarchy install requires: $1"
  echo ""
  echo "To fix:"
  echo "  1. Reinstall Arch with archinstall"
  echo "  2. Select: BTRFS + LUKS + Limine"
  echo "  3. See: https://github.com/Romanhan/romarchy#fresh-install"
  echo ""
  exit 1
}

# Must be Arch Linux
if [[ ! -f /etc/arch-release ]]; then
  abort "Arch Linux (not derivatives)"
fi

# Must not be running as root
if (( EUID == 0 )); then
  abort "Running as regular user (not root)"
fi

# Must be x86_64
if [[ $(uname -m) != "x86_64" ]]; then
  abort "x86_64 CPU"
fi

# Must have BTRFS root filesystem
if [[ $(findmnt -n -o FSTYPE /) != "btrfs" ]]; then
  abort "BTRFS root filesystem"
fi

# Must have LUKS encryption
if ! lsblk -f | grep -q "crypto_LUKS"; then
  abort "LUKS disk encryption"
fi

# Must have Limine installed
if ! command -v limine &>/dev/null; then
  abort "Limine bootloader"
fi

success "System checks passed"
