#!/bin/bash
# Logging functions (Omarchy-style)

LOG_FILE="${ROMARCHY_INSTALL_LOG_FILE:-/var/log/romarchy-install.log}"

run_logged() {
  local script="$1"
  local name
  name=$(basename "$script" .sh)

  echo "" >> "$LOG_FILE"
  echo "━━━ $name ━━━" >> "$LOG_FILE"
  echo "Started: $(date)" >> "$LOG_FILE"

  if bash "$script" >> "$LOG_FILE" 2>&1; then
    echo "Completed: $(date)" >> "$LOG_FILE"
  else
    echo "FAILED: $(date)" >> "$LOG_FILE"
    error "Script failed: $name"
    error "Check log: $LOG_FILE"
    exit 1
  fi
}
