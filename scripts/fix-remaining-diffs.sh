#!/bin/bash
# Fix remaining romarchy vs omarchy differences
# Run with: sudo ~/.local/share/romarchy/scripts/fix-remaining-diffs.sh

set -e

echo "=== Fixing Remaining Romarchy vs Omarchy Differences ==="
echo ""

# 1. Fix /etc/default/limine to match omarchy approach
echo "[1/4] Fixing /etc/default/limine..."

# Fix TARGET_OS_NAME
sed -i 's/^TARGET_OS_NAME=.*/TARGET_OS_NAME="Romarchy"/' /etc/default/limine

# Add missing settings if not present
if ! grep -q "^FIND_BOOTLOADERS=" /etc/default/limine; then
  echo "" >> /etc/default/limine
  echo "# Find and add other bootloaders" >> /etc/default/limine
  echo "FIND_BOOTLOADERS=yes" >> /etc/default/limine
  echo "  Added FIND_BOOTLOADERS=yes"
fi

if ! grep -q "^BOOT_ORDER=" /etc/default/limine; then
  echo "BOOT_ORDER=\"*, *fallback, Snapshots\"" >> /etc/default/limine
  echo "  Added BOOT_ORDER=\"*, *fallback, Snapshots\""
fi

echo "  Updated TARGET_OS_NAME=Romarchy"

# 2. Update post-save script to also fix OS entry name
echo ""
echo "[2/4] Updating post-save script..."
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

# 3. Regenerate boot entries with correct OS name
echo ""
echo "[3/4] Regenerating boot entries..."
limine-update

# 4. Verify the OS entry name changed
echo ""
echo "[4/4] Verifying..."
if grep -q "^/Romarchy" /boot/limine.conf; then
  echo "  SUCCESS: OS entry is now /Romarchy"
elif grep -q "^/Arch Linux" /boot/limine.conf; then
  echo "  WARNING: OS entry still shows /Arch Linux"
  echo "  This may require manual fix or reboot to take effect"
else
  echo "  Checking current OS entry..."
  grep "^/" /boot/limine.conf | head -5
fi

echo ""
echo "=== Done ==="
echo ""
echo "Current limine.conf OS entries:"
grep "^/" /boot/limine.conf
echo ""
echo "Current /etc/default/limine:"
cat /etc/default/limine
