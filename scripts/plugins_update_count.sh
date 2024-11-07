#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Path to TPM plugins directory
TPM_DIR="$(cd "$CURRENT_DIR/../.." && pwd)"
# TPM_DIR="${HOME}/.config/tmux/plugins"

# Source Helpers
source "$CURRENT_DIR/helpers.sh"

print_plugins_update_count() {
  # Function to check for updates in a plugin directory
  check_plugin_updates() {
    local plugin_dir=$1
    local updates=$(cd "${plugin_dir}" && git fetch && git status -uno | grep "Your branch is behind")
    if [ -n "$updates" ]; then
      return 0
    fi
    return 1
  }

  # Iterate through each plugin directory and check for updates
  plugin_updates_count=0
  for plugin in "${TPM_DIR}"/*; do
    if [ -d "${plugin}/.git" ] && [ "${plugin}" != "${TPM_DIR}/tpm" ]; then
      if check_plugin_updates "${plugin}"; then
        plugin_updates_count=$((plugin_updates_count + 1))
      fi
    fi
  done

  # Output the result
  if [ $plugin_updates_count -gt 0 ]; then
    echo "$plugin_updates_count Plugins"
  else
    echo "Up-to-date"
  fi
}

main() {
  print_plugins_update_count
}
main
