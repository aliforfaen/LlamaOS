#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="$HOME/install-logs"
mkdir -p "$LOG_DIR"

echo "⚙️ Running post-install configuration..."

# Ensure config directories exist
mkdir -p "$HOME/.config"

# Deploy Hyprland config
if [ ! -f "$HOME/.config/hypr/hyprland.conf" ]; then
    mkdir -p "$HOME/.config/hypr"
    cp ./dotfiles/hypr/hyprland.conf "$HOME/.config/hypr/"
    echo "✅ Hyprland config deployed."
else
    echo "ℹ️ Hyprland config already exists, skipping."
fi

# Deploy Waybar config
if [ ! -d "$HOME/.config/waybar" ]; then
    cp -r ./dotfiles/waybar "$HOME/.config/"
    echo "✅ Waybar config deployed."
else
    echo "ℹ️ Waybar config exists, skipping."
fi

# Deploy other configs (kitty, foot, mako, etc.)
for DIR in kitty foot mako thunar; do
    if [ -d "./dotfiles/$DIR" ] && [ ! -d "$HOME/.config/$DIR" ]; then
        cp -r "./dotfiles/$DIR" "$HOME/.config/"
        echo "✅ Deployed config: $DIR"
    fi
done

# Enable services
for svc in sddm NetworkManager bluetooth; do
    if systemctl is-enabled --quiet "$svc"; then
        echo "ℹ️ $svc already enabled."
    else
        sudo systemctl enable --now "$svc"
        echo "✅ Enabled service: $svc"
    fi
done

# Locale fix (safe to rerun)
sudo localectl set-locale LANG=en_US.UTF-8

echo "🎉 Post-install configuration complete!"
