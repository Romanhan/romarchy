#!/bin/bash

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
source "$ROMARCHY_DIR/install/helpers/check.sh"

NVIDIA="$(lspci | grep -i 'nvidia')"

if [[ -z $NVIDIA ]]; then
  echo "No NVIDIA GPU detected, skipping NVIDIA setup."
  exit 0
fi

echo "NVIDIA GPU detected, setting up..."

KERNEL_HEADERS="$(pacman -Qqs '^linux(-zen|-lts|-hardened)?$' | head -1)-headers"

if echo "$NVIDIA" | grep -qE "GTX 16[0-9]{2}|RTX [2-5][0-9]{3}|RTX PRO [0-9]{4}|Quadro RTX|RTX A[0-9]{4}|A[1-9][0-9]{2}|H[1-9][0-9]{2}|T4|L[0-9]+"; then
  PACKAGES=(nvidia-open-dkms nvidia-utils lib32-nvidia-utils libva-nvidia-driver)
  GPU_ARCH="turing_plus"
elif echo "$NVIDIA" | grep -qE "GTX (9[0-9]{2}|10[0-9]{2})|GT 10[0-9]{2}|Quadro [PM][0-9]{3,4}|Quadro GV100|MX *[0-9]+|Titan (X|Xp|V)|Tesla V100"; then
  PACKAGES=(nvidia-580xx-dkms nvidia-580xx-utils lib32-nvidia-580xx-utils)
  GPU_ARCH="maxwell_pascal_volta"
fi

if [[ -z ${PACKAGES+x} ]]; then
  echo "No compatible driver for your NVIDIA GPU. See: https://wiki.archlinux.org/title/NVIDIA"
  exit 0
fi

check_and_install "NVIDIA" "$KERNEL_HEADERS" "${PACKAGES[@]}"

echo "Configuring NVIDIA for early KMS..."

sudo tee /etc/modprobe.d/nvidia.conf >/dev/null <<EOF
options nvidia_drm modeset=1
EOF

sudo tee /etc/mkinitcpio.conf.d/nvidia.conf >/dev/null <<EOF
MODULES+=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
EOF

if [[ $GPU_ARCH = "turing_plus" ]]; then
  cat >>"$HOME/.config/hypr/envs.conf" <<'EOF'

# NVIDIA (Turing+ with GSP firmware)
env = NVD_BACKEND,direct
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
EOF
elif [[ $GPU_ARCH = "maxwell_pascal_volta" ]]; then
  cat >>"$HOME/.config/hypr/envs.conf" <<'EOF'

# NVIDIA (Maxwell/Pascal/Volta without GSP firmware)
env = NVD_BACKEND,egl
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
EOF
fi

echo "NVIDIA setup complete."