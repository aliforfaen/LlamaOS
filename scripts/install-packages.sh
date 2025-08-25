#!/usr/bin/env bash
set -euo pipefail

# Logging
LOG_DIR="$HOME/install-logs"
mkdir -p "$LOG_DIR"
MISSING="$LOG_DIR/missing-packages.txt"
> "$MISSING"

echo "📦 Starting package installation..."
echo "Missing packages will be logged in: $MISSING"

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

safe_aur_install() {
    for pkg in "$@"; do
        if $AUR_HELPER -Si "$pkg" &>/dev/null; then
            $AUR_HELPER -S --noconfirm --needed "$pkg"
            echo "✅ Installed (AUR): $pkg"
        else
            echo "⚠️ Not found in AUR: $pkg" | tee -a "$MISSING"
        fi
    done
}

# --- Ensure yay/paru exists ---
if command -v yay >/dev/null 2>&1; then
    AUR_HELPER="yay"
    echo "🔧 Using yay for AUR installs."
elif command -v paru >/dev/null 2>&1; then
    AUR_HELPER="paru"
    echo "🔧 Using paru for AUR installs."
else
    echo "⚠️ No AUR helper found. Installing yay..."
    sudo pacman -S --noconfirm --needed git base-devel
    if [ ! -d "$HOME/.yay" ]; then
        git clone https://aur.archlinux.org/yay.git "$HOME/.yay"
    fi
    pushd "$HOME/.yay"
    makepkg -si --noconfirm
    popd
    AUR_HELPER="yay"
    echo "✅ yay installed successfully."
fi

# Official repo packages
safe_pacman_install \
    hyprland xorg-xwayland waybar thunar thunar-archive-plugin thunar-volman \
    file-roller gvfs wl-clipboard cliphist grim slurp mako nwg-look wlogout \
    foot kitty pavucontrol blueberry network-manager-applet

# AUR packages
safe_aur_install \
    clipman timeshift-autosnap wayland-bongocat-git lazydocker

echo "🎉 Package installation complete!"
echo "Check $MISSING for skipped packages."
