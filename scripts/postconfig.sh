#!/usr/bin/env bash
# =========================================
#  LlamaOS 🦙 Post-Configuration Script
# =========================================
# Applies locale, timezone, keymap, and symlinks dotfiles
# Run this *after* install-packages.sh on a fresh Arch base.
# -----------------------------------------

set -e

echo ">>> Configuring locale and timezone..."

# Locale: English (US), UI language
sudo sed -i '/en_US.UTF-8/s/^#//' /etc/locale.gen
echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf
sudo locale-gen

# Timezone: Europe/Oslo
sudo timedatectl set-timezone Europe/Oslo

# Keyboard: Norwegian layout (but English UI set above)
sudo localectl set-x11-keymap no
sudo localectl set-keymap no

echo ">>> Locale, timezone and keymap done."

# ------------------------------------------------------

echo ">>> Setting up dotfiles with stow..."
# Ensure stow is installed
if ! command -v stow &>/dev/null; then
    echo ">>> Installing stow..."
    sudo pacman -S --noconfirm stow
fi

cd ~/LlamaOS/dotfiles

# Symlink configs into ~/.config
stow -t ~/.config hypr
stow -t ~/.config waybar
stow -t ~/.config rofi

echo ">>> Dotfiles have been symlinked to ~/.config."

# ------------------------------------------------------

echo ">>> Enabling user services (swaync, clipman restore)..."
# For example: notification daemon autostart
systemctl --user enable --now swaync.service || true

echo
echo ">>> Post-install configuration complete! 🦙"
echo "Reboot and log into Hyprland via SDDM to start using LlamaOS."
