#!/usr/bin/env bash
# =========================================
#  LlamaOS 🦙 Upgrade Script
# =========================================
# Runs a safe system upgrade:
# 1. Creates a Timeshift snapshot ("pre-upgrade")
# 2. Runs yay -Syu to upgrade all repos + AUR
# 3. Handles errors gracefully
# -----------------------------------------

set -e

echo ">>> Creating Timeshift snapshot: pre-upgrade"
if sudo timeshift --create --comments "Pre-upgrade $(date '+%Y-%m-%d %H:%M')" --tags D; then
    echo ">>> Snapshot created successfully."
else
    echo "⚠️ Warning: Timeshift snapshot failed. Proceeding without snapshot..."
fi

echo ">>> Running yay system upgrade..."
if yay -Syu; then
    echo ">>> Upgrade complete! 🦙"
else
    echo "❌ Error: Upgrade failed. Consider restoring snapshot."
fi
