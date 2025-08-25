#!/usr/bin/env bash
set -euo pipefail

# Logging
LOG_DIR="$HOME/install-logs"
mkdir -p "$LOG_DIR"
MISSING="$LOG_DIR/missing-packages.txt"
> "$MISSING"

echo "📦 Starting package installation..."
echo "Missing packages will be logged in: $MISSING"

# Safe pacman install
safe_pacman_install() {
    for pkg in "$@"; do
        if pacman -Si "$pkg" &>/dev/null; then
            sudo pacman -S --noconfirm --needed "$pkg"
            echo "✅ Installed (pacman): $pkg"
        else
            echo "⚠️ Not found in pacman: $pkg" | tee -a "$MISSING"
        fi
    done
}

# Safe yay install (AUR)
safe_yay_install() {
    for pkg in "$@"; do
        if yay -Si "$pkg" &>/dev/null; then
            yay -S --noconfirm --needed "$pkg"
            echo "✅ Installed (AUR): $pkg"
        else
            echo "⚠️ Not found in AUR: $pkg" | tee -a "$MISSING"
        fi
    done
}

# Official repo packages
safe_pacman_install \
    hyprland xorg-xwayland waybar thunar thunar-archive-plugin thunar-volman \
    file-roller gvfs wl-clipboard cliphist grim slurp mako nwg-look wlogout \
    foot kitty pavucontrol blueberry network-manager-applet

# AUR packages
if command -v yay >/dev/null 2>&1; then
    safe_yay_install \
        clipman timeshift-autosnap wayland-bongocat-git lazydocker
else
    echo "⚠️ yay not installed. Skipping AUR packages." | tee -a "$MISSING"
fi

echo "🎉 Package installation complete!"
echo "Check $MISSING for skipped packages."
