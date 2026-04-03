#!/bin/bash
# Create EFI boot entries for Romarchy (Omarchy-style)
# Romarchy = direct UKI boot (no menu)
# Limine = bootloader with snapshots (for recovery)

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
source "$ROMARCHY_DIR/install/helpers/ui.sh"

header "Creating EFI Boot Entries (Optional)"

# Check if running on UEFI
if [[ ! -d /sys/firmware/efi ]]; then
  warn "Not running on UEFI, skipping boot entries"
  exit 0
fi

# Check if efibootmgr is available
if ! command -v efibootmgr &>/dev/null; then
  info "Installing efibootmgr..."
  sudo pacman -S --noconfirm --needed efibootmgr
fi

# Detect disk and partition
ESP_DEVICE=$(findmnt -n -o SOURCE /boot)
# Handle NVMe naming (nvme0n1p1 -> disk=/dev/nvme0n1, part=1)
if [[ "$ESP_DEVICE" =~ ^/dev/(nvme[0-9]+n[0-9]+)p([0-9]+)$ ]]; then
  ESP_DISK="/dev/${BASH_REMATCH[1]}"
  ESP_PART="${BASH_REMATCH[2]}"
else
  ESP_DISK=$(echo "$ESP_DEVICE" | sed 's/[0-9]*$//')
  ESP_PART=$(echo "$ESP_DEVICE" | grep -o '[0-9]*$')
fi

if [[ -z "$ESP_DISK" ]] || [[ -z "$ESP_PART" ]]; then
  error "Could not detect disk/partition from $ESP_DEVICE"
  exit 1
fi

info "Detected: disk=$ESP_DISK, partition=$ESP_PART"

# Check if UKI exists
UKI_PATH="/boot/EFI/Linux/romarchy_linux.efi"
if [[ ! -f "$UKI_PATH" ]]; then
  if [[ -f "/boot/EFI/Linux/arch-linux.efi" ]]; then
    UKI_PATH="/boot/EFI/Linux/arch-linux.efi"
    warn "Using existing UKI: $UKI_PATH"
    warn "Run 'mkinitcpio -p linux' to generate romarchy_linux.efi"
  else
    error "UKI not found at $UKI_PATH or /boot/EFI/Linux/arch-linux.efi"
    error "Run 'mkinitcpio -p linux' first to generate UKI"
    exit 1
  fi
fi

# Check if Limine EFI exists
LIMINE_PATH="/boot/EFI/limine/limine_x64.efi"
if [[ ! -f "$LIMINE_PATH" ]]; then
  error "Limine EFI not found at $LIMINE_PATH"
  exit 1
fi

# Remove old Romarchy/Limine entries if they exist (Omarchy-style)
info "Cleaning up old boot entries..."
while IFS= read -r line; do
  if [[ $line =~ ^Boot([0-9]{4})\*?\ (Romarchy|Limine) ]]; then
    bootnum="${BASH_REMATCH[1]}"
    info "Removing old entry: Boot$bootnum"
    sudo efibootmgr -b "$bootnum" -B >/dev/null 2>&1
  fi
done < <(efibootmgr)

# Create Romarchy entry (direct UKI boot - no menu)
# Convert to ESP-relative path (strip /boot prefix since /boot IS the ESP mount point)
ESP_UKI_LOADER="${UKI_PATH#/boot}"
info "Creating Romarchy entry (direct boot)..."
info "  ESP-relative loader path: $ESP_UKI_LOADER"
sudo efibootmgr --create --disk "$ESP_DISK" --part "$ESP_PART" --loader "$ESP_UKI_LOADER" --label "Romarchy"

# Create Limine entry (bootloader with snapshots - for recovery)
ESP_LIMINE_LOADER="${LIMINE_PATH#/boot}"
info "Creating Limine entry (recovery/snapshots)..."
info "  ESP-relative loader path: $ESP_LIMINE_LOADER"
sudo efibootmgr --create --disk "$ESP_DISK" --part "$ESP_PART" --loader "$ESP_LIMINE_LOADER" --label "Limine"

# Set boot order: Romarchy first, then Limine
ROMARCHY_NUM=$(efibootmgr | grep "Romarchy" | grep -o 'Boot[0-9]*' | grep -o '[0-9]*')
LIMINE_NUM=$(efibootmgr | grep "Limine" | grep -o 'Boot[0-9]*' | grep -o '[0-9]*')

if [[ -n "$ROMARCHY_NUM" ]] && [[ -n "$LIMINE_NUM" ]]; then
  info "Setting boot order: Romarchy → Limine"
  sudo efibootmgr -o "$ROMARCHY_NUM,$LIMINE_NUM"
fi

# Copy UKI as fallback bootloader (handles BIOS that ignore EFI boot order)
info "Copying UKI as fallback bootloader..."
sudo cp "$UKI_PATH" /boot/EFI/BOOT/BOOTX64.EFI
info "  BOOTX64.EFI now points to Romarchy UKI"

echo ""
success "EFI boot entries created"
echo ""
info "Boot order:"
info "  1. Romarchy — direct UKI boot (no menu)"
info "  2. Limine — shows Limine menu with snapshots"
echo ""
info "Set 'Romarchy' as first in your BIOS for direct boot"
info "Select 'Limine' from BIOS boot menu for snapshot recovery"
