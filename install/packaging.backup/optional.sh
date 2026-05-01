#!/bin/bash
# Optional packages - prompts user after base install
# Omarchy pattern: interactive selection

ROMARCHY_DIR="${ROMARCHY_DIR:-$HOME/.local/share/romarchy}"
source "$ROMARCHY_DIR/install/helpers/ui.sh"
source "$ROMARCHY_DIR/install/helpers/check.sh"

header "Optional Packages"

# Define optional packages with descriptions
declare -A OPTIONAL_PACKAGES=(
  ["libreoffice-fresh"]="LibreOffice (office suite)"
  ["lazygit"]="LazyGit (TUI git client)"
  ["bibata-cursor-theme"]="Bibata cursor theme"
  ["visual-studio-code-bin"]="VS Code (editor)"
  ["ai-tools"]="AI tools (claude-code, etc.)"
)

SELECTED=""

for pkg in "${!OPTIONAL_PACKAGES[@]}"; do
  desc="${OPTIONAL_PACKAGES[$pkg]}"
  if ask "Install $desc? ($pkg)"; then
    if [[ $pkg == "ai-tools" ]]; then
      # Special handling for AI tools
      if [[ -f $ROMARCHY_DIR/bin/ai-install ]]; then
        bash "$ROMARCHY_DIR/bin/ai-install"
        SELECTED="$SELECTED ai-tools"
      fi
    else
      check_and_install "Optional" "$pkg"
      SELECTED="$SELECTED $pkg"
    fi
  fi
done

echo ""
if [[ -n $SELECTED ]]; then
  success "Selected optional packages:$SELECTED"
else
  info "No optional packages selected"
fi
