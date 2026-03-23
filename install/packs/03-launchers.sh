#!/bin/bash

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
source "$ROMARCHY_DIR/install/helpers/check.sh"
source "$ROMARCHY_DIR/install/helpers/ui.sh"

check_and_install "Launchers" \
  walker-bin \
  elephant \
  impala

link_elephant_providers() {
  echo ""
  echo -e "\033[1;34m═══ Linking Elephant Providers ═══\033[0m"
  mkdir -p ~/.config/elephant/providers
  if [[ -d /usr/lib/elephant/ ]]; then
    for provider in /usr/lib/elephant/*.so; do
      if [[ -f "$provider" ]]; then
        local name=$(basename "$provider")
        if [[ ! -L ~/.config/elephant/providers/"$name" ]]; then
          ln -sf "$provider" ~/.config/elephant/providers/"$name"
          echo -e "  \033[32m✓\033[0m $name"
        else
          echo -e "  \033[33m~\033[0m $name (already linked)"
        fi
      fi
    done
  else
    echo -e "  \033[33m!\033[0m Elephant providers not found at /usr/lib/elephant/"
  fi
}

link_elephant_providers
