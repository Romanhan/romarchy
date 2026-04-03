#!/bin/bash
# Quick fix: Restore romarchy limine settings and configure auto-preservation
# Run with: sudo ~/.local/share/romarchy/scripts/fix-limine-menu.sh

echo "Fixing limine menu issue..."

# Create post-save script
cat > /usr/local/bin/romarchy-limine-post-save <<'EOF'
#!/bin/bash
# Restore romarchy limine settings after limine-snapper-sync regeneration
sed -i 's/^timeout: 3/#timeout: 3/' /boot/limine.conf
sed -i 's/^default_entry: .*/default_entry: 2/' /boot/limine.conf
sed -i 's/^interface_branding: .*/interface_branding: Romarchy Bootloader/' /boot/limine.conf
sed -i 's/^interface_branding_color: .*/interface_branding_color: 2/' /boot/limine.conf
EOF
chmod +x /usr/local/bin/romarchy-limine-post-save

# Update limine-snapper-sync config
sed -i 's|^COMMANDS_AFTER_SAVE=.*|COMMANDS_AFTER_SAVE="limine-enroll-config; /usr/local/bin/romarchy-limine-post-save"|' /etc/limine-snapper-sync.conf

# Apply settings immediately
sed -i 's/^timeout: 3/#timeout: 3/' /boot/limine.conf
sed -i 's/^default_entry: .*/default_entry: 2/' /boot/limine.conf
sed -i 's/^interface_branding: .*/interface_branding: Romarchy Bootloader/' /boot/limine.conf
sed -i 's/^interface_branding_color: .*/interface_branding_color: 2/' /boot/limine.conf

# Enroll the updated config
limine-enroll-config

echo "Done! Limine menu is now hidden. Direct boot to Romarchy restored."
echo "Settings will be preserved after future snapshot creations."
