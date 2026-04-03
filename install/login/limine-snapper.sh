#!/bin/bash
# Romarchy Limine + Snapper Setup (Omarchy-style)

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
source "$ROMARCHY_DIR/install/helpers/ui.sh"

header "Setting up Limine + Snapper"

# Check if limine is installed
if ! command -v limine &>/dev/null; then
  warn "Limine not found, skipping limine-snapper setup"
  exit 0
fi

# Install packages
info "Installing packages..."
sudo pacman -S --noconfirm --needed snapper inotify-tools btrfs-progs
yay -S --noconfirm --needed limine-snapper-sync limine-mkinitcpio-hook

# Setup mkinitcpio hooks (add btrfs-overlayfs only)
info "Configuring mkinitcpio hooks..."
sudo tee /etc/mkinitcpio.conf.d/romarchy_hooks.conf <<EOF >/dev/null
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck btrfs-overlayfs)
EOF

# Detect boot mode
[[ -d /sys/firmware/efi ]] && EFI=true

# Find config location (Omarchy-style)
if [[ -f /boot/EFI/arch-limine/limine.conf ]]; then
  limine_config="/boot/EFI/arch-limine/limine.conf"
elif [[ -f /boot/EFI/BOOT/limine.conf ]]; then
  limine_config="/boot/EFI/BOOT/limine.conf"
elif [[ -f /boot/EFI/limine/limine.conf ]]; then
  limine_config="/boot/EFI/limine/limine.conf"
elif [[ -f /boot/limine/limine.conf ]]; then
  limine_config="/boot/limine/limine.conf"
elif [[ -f /boot/limine.conf ]]; then
  limine_config="/boot/limine.conf"
else
  error "Limine config not found"
  exit 1
fi

# Extract cmdline from existing config
CMDLINE=$(grep "^[[:space:]]*cmdline:" "$limine_config" | head -1 | sed 's/^[[:space:]]*cmdline:[[:space:]]*//')

if [[ -z "$CMDLINE" ]]; then
  error "Could not extract cmdline from $limine_config"
  exit 1
fi

# Copy and configure /etc/default/limine
info "Configuring /etc/default/limine..."
sudo cp "$ROMARCHY_DIR/default/limine/default.conf" /etc/default/limine
sudo sed -i "s|@@CMDLINE@@|$CMDLINE|g" /etc/default/limine

# Append any drop-in kernel cmdline configs
for dropin in /etc/limine-entry-tool.d/*.conf; do
  [ -f "$dropin" ] && cat "$dropin" | sudo tee -a /etc/default/limine >/dev/null
done

# UKI and EFI fallback are EFI only
if [[ -z $EFI ]]; then
  sudo sed -i '/^ENABLE_UKI=/d; /^ENABLE_LIMINE_FALLBACK=/d' /etc/default/limine
fi

# Remove old config if different from /boot/limine.conf
if [[ $limine_config != "/boot/limine.conf" ]] && [[ -f $limine_config ]]; then
  sudo rm "$limine_config"
fi

# Copy fresh romarchy theme to limine.conf
info "Setting up Limine theme..."
sudo cp "$ROMARCHY_DIR/default/limine/limine.conf" /boot/limine.conf

# Configure limine-snapper-sync to restore custom settings after regeneration
# This prevents limine-snapper-sync from overriding our direct-boot configuration
info "Configuring limine-snapper-sync to preserve custom settings..."
sudo tee /usr/local/bin/romarchy-limine-post-save <<'EOF' >/dev/null
#!/bin/bash
# Restore romarchy limine settings after limine-snapper-sync regeneration
# Use ^#* to match both commented and uncommented lines
sed -i 's/^#*interface_branding: .*/interface_branding: Romarchy Bootloader/' /boot/limine.conf
sed -i 's/^#*interface_branding_color: .*/interface_branding_color: 2/' /boot/limine.conf
sed -i 's/^timeout: 3/#timeout: 3/' /boot/limine.conf
sed -i 's/^default_entry: .*/default_entry: 2/' /boot/limine.conf
EOF
sudo chmod +x /usr/local/bin/romarchy-limine-post-save

# Update limine-snapper-sync config to use our post-save script
# IMPORTANT: Post-save script runs FIRST to modify limine.conf, THEN limine-enroll-config enrolls it
sudo sed -i 's|^COMMANDS_AFTER_SAVE=.*|COMMANDS_AFTER_SAVE="/usr/local/bin/romarchy-limine-post-save && limine-enroll-config"|' /etc/limine-snapper-sync.conf

# Install pacman hook to restore UKI as fallback after limine updates
# This prevents limine-install from overwriting BOOTX64.EFI with limine
info "Installing fallback restore hook..."
sudo mkdir -p /etc/pacman.d/hooks
sudo cp "$ROMARCHY_DIR/default/limine/99-romarchy-fallback-restore.hook" /etc/pacman.d/hooks/99-romarchy-fallback-restore.hook

# Re-enable mkinitcpio hooks (Omarchy-style)
if [[ -f /usr/share/libalpm/hooks/90-mkinitcpio-install.hook.disabled ]]; then
  sudo mv /usr/share/libalpm/hooks/90-mkinitcpio-install.hook.disabled /usr/share/libalpm/hooks/90-mkinitcpio-install.hook
fi
if [[ -f /usr/share/libalpm/hooks/60-mkinitcpio-remove.hook.disabled ]]; then
  sudo mv /usr/share/libalpm/hooks/60-mkinitcpio-remove.hook.disabled /usr/share/libalpm/hooks/60-mkinitcpio-remove.hook
fi

# Setup snapper configs (root AND home, like Omarchy)
info "Setting up Snapper..."
if ! sudo snapper list-configs 2>/dev/null | grep -q "root"; then
  sudo snapper -c root create-config /
fi
if ! sudo snapper list-configs 2>/dev/null | grep -q "home"; then
  sudo snapper -c home create-config /home
fi

# Setup snapshots subvolume
if ! sudo btrfs subvolume list / 2>/dev/null | grep -q ".snapshots"; then
  sudo umount /.snapshots 2>/dev/null
  sudo btrfs subvolume delete /.snapshots 2>/dev/null
  sudo rm -rf /.snapshots 2>/dev/null
  sudo btrfs subvolume create /.snapshots
  sudo mkdir -p /.snapshots
  sudo mount /.snapshots
fi

# Enable quota for space-aware algorithms
sudo btrfs quota enable /

# Tweak snapper configs (3 snapshots max, like Omarchy)
sudo sed -i 's/^NUMBER_LIMIT="50"/NUMBER_LIMIT="3"/' /etc/snapper/configs/{root,home}
sudo sed -i 's/^NUMBER_LIMIT_IMPORTANT="10"/NUMBER_LIMIT_IMPORTANT="3"/' /etc/snapper/configs/{root,home}
sudo sed -i 's/^SPACE_LIMIT="0.5"/SPACE_LIMIT="0.3"/' /etc/snapper/configs/{root,home}
sudo sed -i 's/^FREE_LIMIT="0.2"/FREE_LIMIT="0.3"/' /etc/snapper/configs/{root,home}

# User wants weekly snapshots (different from Omarchy's no-timeline)
# Set timeline to weekly only, 1 snapshot per week (3 total max)
sudo sed -i 's/^TIMELINE_CREATE="yes"/TIMELINE_CREATE="yes"/' /etc/snapper/configs/{root,home}
sudo sed -i 's/^TIMELINE_LIMIT_HOURLY="[0-9]*"/TIMELINE_LIMIT_HOURLY="0"/' /etc/snapper/configs/{root,home}
sudo sed -i 's/^TIMELINE_LIMIT_DAILY="[0-9]*"/TIMELINE_LIMIT_DAILY="0"/' /etc/snapper/configs/{root,home}
sudo sed -i 's/^TIMELINE_LIMIT_WEEKLY="[0-9]*"/TIMELINE_LIMIT_WEEKLY="1"/' /etc/snapper/configs/{root,home}
sudo sed -i 's/^TIMELINE_LIMIT_MONTHLY="[0-9]*"/TIMELINE_LIMIT_MONTHLY="0"/' /etc/snapper/configs/{root,home}
sudo sed -i 's/^TIMELINE_LIMIT_QUARTERLY="[0-9]*"/TIMELINE_LIMIT_QUARTERLY="0"/' /etc/snapper/configs/{root,home}
sudo sed -i 's/^TIMELINE_LIMIT_YEARLY="[0-9]*"/TIMELINE_LIMIT_YEARLY="0"/' /etc/snapper/configs/{root,home}

# Enable services
info "Enabling services..."
sudo systemctl enable --now limine-snapper-sync.service
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer

# Generate UKI (Omarchy-style)
info "Generating UKI..."
sudo limine-mkinitcpio

# Copy UKI as fallback bootloader (handles BIOS that ignore EFI boot order)
info "Copying UKI as fallback bootloader..."
sudo cp /boot/EFI/Linux/romarchy_linux.efi /boot/EFI/BOOT/BOOTX64.EFI

# Run limine-update to generate boot entries
info "Generating boot entries..."
sudo limine-update

# Remove stale /Arch Linux entry if present (limine-update may create it from /etc/os-release)
info "Cleaning stale boot entries..."
sudo awk '
BEGIN { skip=0 }
/^\/Arch Linux$/ { skip=1; next }
skip && /^\/[^ ]/ { skip=0 }
skip && /^\/\+/ { skip=0 }
!skip { print }
' /boot/limine.conf > /tmp/limine-clean.conf
sudo mv /tmp/limine-clean.conf /boot/limine.conf
sudo limine-enroll-config

# Verify limine-update added entries
if ! grep -q "^/+" /boot/limine.conf; then
  error "limine-update failed to add boot entries"
  exit 1
fi

# Remove old Arch Linux Limine entries (Omarchy-style)
if [[ -n $EFI ]] && efibootmgr &>/dev/null; then
  while IFS= read -r bootnum; do
    sudo efibootmgr -b "$bootnum" -B >/dev/null 2>&1
  done < <(efibootmgr | grep -E "^Boot[0-9]{4}\*? Arch Linux Limine" | sed 's/^Boot\([0-9]\{4\}\).*/\1/')
fi

# Copy romarchy-snapshot script
info "Installing romarchy-snapshot..."
sudo cp "$ROMARCHY_DIR/bin/romarchy-snapshot" /usr/local/bin/romarchy-snapshot
sudo chmod +x /usr/local/bin/romarchy-snapshot

success "Limine + Snapper setup complete"
echo ""
info "Next: Run post-install to create EFI boot entries (optional)"
info "Then: Set 'Romarchy' as first boot option in BIOS"
