#!/bin/bash
# Fix Romarchy direct UKI boot (Omarchy-style)
# Run with: sudo ~/.local/share/romarchy/scripts/fix-direct-boot.sh

set -e

echo "=== Fixing Romarchy Direct UKI Boot ==="
echo ""

# 1. Add ENABLE_UKI=yes and CUSTOM_UKI_NAME=romarchy to /etc/default/limine
echo "[1/6] Configuring /etc/default/limine for UKI generation..."
if ! grep -q "^ENABLE_UKI=" /etc/default/limine; then
  echo "ENABLE_UKI=yes" >> /etc/default/limine
  echo "  Added ENABLE_UKI=yes"
else
  sed -i 's/^ENABLE_UKI=.*/ENABLE_UKI=yes/' /etc/default/limine
  echo "  Updated ENABLE_UKI=yes"
fi

if ! grep -q "^CUSTOM_UKI_NAME=" /etc/default/limine; then
  echo "CUSTOM_UKI_NAME=\"romarchy\"" >> /etc/default/limine
  echo "  Added CUSTOM_UKI_NAME=romarchy"
else
  sed -i 's/^CUSTOM_UKI_NAME=.*/CUSTOM_UKI_NAME="romarchy"/' /etc/default/limine
  echo "  Updated CUSTOM_UKI_NAME=romarchy"
fi

# 2. Fix COMMANDS_AFTER_SAVE order (modify first, then enroll)
echo ""
echo "[2/6] Fixing COMMANDS_AFTER_SAVE order..."
sed -i 's|^COMMANDS_AFTER_SAVE=.*|COMMANDS_AFTER_SAVE="/usr/local/bin/romarchy-limine-post-save && limine-enroll-config"|' /etc/limine-snapper-sync.conf
echo "  Updated: COMMANDS_AFTER_SAVE=\"/usr/local/bin/romarchy-limine-post-save && limine-enroll-config\""

# 3. Update post-save script to handle commented lines
echo ""
echo "[3/6] Updating post-save script..."
cat > /usr/local/bin/romarchy-limine-post-save <<'POSTSAVE'
#!/bin/bash
# Restore romarchy limine settings after limine-snapper-sync regeneration
sed -i 's/^#*interface_branding: .*/interface_branding: Romarchy Bootloader/' /boot/limine.conf
sed -i 's/^#*interface_branding_color: .*/interface_branding_color: 2/' /boot/limine.conf
sed -i 's/^timeout: 3/#timeout: 3/' /boot/limine.conf
sed -i 's/^default_entry: .*/default_entry: 2/' /boot/limine.conf
POSTSAVE
chmod +x /usr/local/bin/romarchy-limine-post-save
echo "  Updated /usr/local/bin/romarchy-limine-post-save"

# 4. Generate UKI
echo ""
echo "[4/6] Generating UKI..."
limine-mkinitcpio
echo "  UKI generated"

# Verify UKI exists
if ls /boot/EFI/Linux/romarchy_*.efi 1>/dev/null 2>&1; then
  UKI_FILE=$(ls /boot/EFI/Linux/romarchy_*.efi | head -1)
  echo "  Found: $UKI_FILE"
else
  echo "  WARNING: UKI not found at expected location, checking alternatives..."
  ls -la /boot/EFI/Linux/
fi

# 5. Run limine-update to regenerate boot entries
echo ""
echo "[5/6] Regenerating boot entries..."
limine-update

# 6. Create EFI boot entries
echo ""
echo "[6/6] Creating EFI boot entries..."

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
  echo "  ERROR: Could not detect disk/partition from $ESP_DEVICE"
  exit 1
fi

echo "  Detected: disk=$ESP_DISK, partition=$ESP_PART"

# Find UKI path
UKI_PATH=""
if ls /boot/EFI/Linux/romarchy_*.efi 1>/dev/null 2>&1; then
  UKI_PATH=$(ls /boot/EFI/Linux/romarchy_*.efi | head -1)
elif [[ -f "/boot/EFI/Linux/arch-linux.efi" ]]; then
  UKI_PATH="/boot/EFI/Linux/arch-linux.efi"
fi

if [[ -z "$UKI_PATH" ]]; then
  echo "  ERROR: No UKI file found"
  exit 1
fi

echo "  Using UKI: $UKI_PATH"

# Remove old Romarchy/Limine entries
echo "  Cleaning old entries..."
while IFS= read -r line; do
  if [[ $line =~ ^Boot([0-9]{4})\*?\ (Romarchy|Limine) ]]; then
    bootnum="${BASH_REMATCH[1]}"
    echo "    Removing Boot$bootnum"
    efibootmgr -b "$bootnum" -B >/dev/null 2>&1
  fi
done < <(efibootmgr)

# Convert filesystem paths to ESP-relative paths for efibootmgr
# efibootmgr --loader expects paths relative to ESP root, not Linux root
# Since /boot IS the ESP mount point, strip /boot prefix
ESP_LOADER_UKI="${UKI_PATH#/boot}"
ESP_LOADER_LIMINE="/EFI/limine/limine_x64.efi"

# Create Romarchy entry (direct UKI boot)
echo "  Creating Romarchy entry..."
efibootmgr --create --disk "$ESP_DISK" --part "$ESP_PART" --loader "$ESP_LOADER_UKI" --label "Romarchy"

# Create Limine entry (recovery)
echo "  Creating Limine entry..."
efibootmgr --create --disk "$ESP_DISK" --part "$ESP_PART" --loader "$ESP_LOADER_LIMINE" --label "Limine"

# Set boot order
ROMARCHY_NUM=$(efibootmgr | grep "Romarchy" | grep -o 'Boot[0-9]*' | grep -o '[0-9]*')
LIMINE_NUM=$(efibootmgr | grep "Limine" | grep -o 'Boot[0-9]*' | grep -o '[0-9]*')

if [[ -n "$ROMARCHY_NUM" ]] && [[ -n "$LIMINE_NUM" ]]; then
  echo "  Setting boot order: Romarchy → Limine"
  efibootmgr -o "$ROMARCHY_NUM,$LIMINE_NUM"
fi

echo ""
echo "=== Done! ==="
echo ""
echo "Boot order:"
efibootmgr | grep -E "BootOrder|Romarchy|Limine"
echo ""
echo "Next reboot will boot directly to Romarchy (no limine menu)."
echo "Access Limine for snapshot recovery via BIOS boot menu."
