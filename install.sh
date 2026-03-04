#!/usr/bin/env bash
# sshmux install script
# https://github.com/aaronontheweb/sshmux

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${HOME}/.local/bin"
CONFIG_DIR="${HOME}/.config/sshmux"

echo ""
echo "Installing sshmux..."
echo ""

# Create install dir and copy script
mkdir -p "$INSTALL_DIR"
cp "$SCRIPT_DIR/sshmux" "$INSTALL_DIR/sshmux"
chmod +x "$INSTALL_DIR/sshmux"
echo "  Installed: $INSTALL_DIR/sshmux"

# Create config dir
mkdir -p "$CONFIG_DIR"
echo "  Config dir: $CONFIG_DIR"

echo ""

# Warn if install dir isn't on PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
  echo "  NOTE: $INSTALL_DIR is not on your PATH."
  echo "  Add this line to your ~/.bashrc (or ~/.bash_profile):"
  echo ""
  echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo ""
fi

# Run onboarding if no config exists yet
if [[ ! -f "$CONFIG_DIR/config" ]]; then
  "$INSTALL_DIR/sshmux" init
else
  echo "  Config already exists. Run 'sshmux help' to get started."
fi

echo ""
echo "Done. Run 'sshmux help' to see available commands."
