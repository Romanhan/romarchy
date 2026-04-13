#!/bin/bash

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"

check_pkg() {
  local pkg="$1"
  if pacman -Q "$pkg" &>/dev/null; then
    return 0
  elif command -v yay &>/dev/null && yay -Q "$pkg" &>/dev/null; then
    return 0
  fi
  return 1
}

check_and_install() {
  local pack="$1"
  shift
  local packages=("$@")
  local missing=()
  local failed=()
  local installed=()

  echo ""
  echo -e "\033[1;34m═══ $pack ═══\033[0m"
  echo ""

  for pkg in "${packages[@]}"; do
    if check_pkg "$pkg"; then
      installed+=("$pkg")
      echo -e "  \033[32m✓\033[0m $pkg (installed)"
    else
      missing+=("$pkg")
      echo -e "  \033[33m○\033[0m $pkg (missing)"
    fi
  done

  if [[ ${#missing[@]} -eq 0 ]]; then
    return 0
  fi

  echo ""
  echo -e "\033[1;33mInstalling ${#missing[@]} package(s)...\033[0m"
  
  for pkg in "${missing[@]}"; do
    local retries=0
    local max_retries=2
    
    while [[ $retries -lt $max_retries ]]; do
      echo -n "  Installing $pkg... "
      
      local install_cmd=""
      if pacman -Si "$pkg" &>/dev/null; then
        install_cmd="sudo pacman -S --noconfirm $pkg"
      elif command -v yay &>/dev/null; then
        install_cmd="yay -S --noconfirm $pkg"
      else
        echo -e "  \033[31m✗\033[0m yay not installed, cannot install AUR package"
        failed+=("$pkg")
        continue
      fi
      
      if eval "$install_cmd" 2>&1; then
        if check_pkg "$pkg"; then
          echo -e "\033[32m✓\033[0m"
          break
        else
          echo -e "\033[31m✗\033[0m"
        fi
      else
        echo -e "\033[31m✗\033[0m"
      fi
      
      ((retries++))
      
      if [[ $retries -lt $max_retries ]]; then
        echo -e "    \033[33m! Installation failed. Retry? [y/N]\033[0m"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
          failed+=("$pkg")
          break
        fi
        echo ""
        echo -n "    Retrying ($retries/$max_retries)... "
      else
        echo -e "    \033[31m! Max retries reached\033[0m"
        failed+=("$pkg")
      fi
    done
  done

  if [[ ${#failed[@]} -gt 0 ]]; then
    echo ""
    echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\033[1;31m Failed packages:\033[0m"
    for pkg in "${failed[@]}"; do
      echo -e "  \033[31m✗\033[0m $pkg"
    done
    echo ""
    echo -e "\033[33m! Some packages failed. Check log above for errors.\033[0m"
    return 1
  fi

  return 0
}
