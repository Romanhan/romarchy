#!/bin/bash

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"

echo ""
echo -e "\033[1;36m═══ LazyVim Setup ═══\033[0m"

setup_lazyvim() {
  local nvim_dir="$HOME/.config/nvim"
  local lazyvim_starter="https://github.com/LazyVim/starter"
  
  echo ""
  echo -n "Backing up existing nvim config... "
  if [[ -e "$nvim_dir" ]]; then
    mv "$nvim_dir" "$nvim_dir.bak.$(date +%s)"
    echo -e "\033[32m✓\033[0m"
  else
    echo -e "\033[33m~\033[0m (none to backup)"
  fi
  
  echo -n "Cloning LazyVim starter... "
  git clone --depth 1 "$lazyvim_starter" "$nvim_dir" 2>/dev/null
  if [[ $? -eq 0 ]]; then
    echo -e "\033[32m✓\033[0m"
  else
    echo -e "\033[31m✗\033[0m"
    return 1
  fi
  
  echo -n "Moving .git to preserve update capability... "
  if [[ -d "$nvim_dir/.git" ]]; then
    mv "$nvim_dir/.git" "$nvim_dir/.git.bak" 2>/dev/null || true
    echo -e "\033[32m✓\033[0m"
  else
    echo -e "\033[33m~\033[0m"
  fi
  
  echo ""
  echo -e "\033[1;33mLazyVim installed! Run 'nvim' to install plugins.\033[0m"
}

if [[ -d "$HOME/.config/nvim" ]] && [[ ! -z "$(ls -A "$HOME/.config/nvim" 2>/dev/null)" ]]; then
  echo ""
  echo "Existing nvim config detected."
  read -p "  Overwrite? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    setup_lazyvim
  else
    echo -e "\033[33mSkipped.\033[0m"
  fi
else
  setup_lazyvim
fi

echo ""
echo -e "\033[32mDone!\033[0m"
