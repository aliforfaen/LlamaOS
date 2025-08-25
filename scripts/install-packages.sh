#!/usr/bin/env bash

# =========================================
#  LlamaOS 🦙 Package Install Script (with yay + graceful failures)
# =========================================
# Installs Arch repo packages and selected AUR packages
# using yay. Skips modules if they fail to install instead of aborting.
# -----------------------------------------

set -e

echo ">>> Updating system..."
sudo pacman -Syu --noconfirm

echo ">>> Installing base tools (needed for yay)..."
sudo pacman -S --noconfirm --needed \
    base-devel \
    git wget curl unzip zip \
    linux-headers

# =========================================
# Yay (AUR helper, Omarchy-style)
# =========================================
if ! command -v yay &>/dev/null; then
    echo ">>> Installing yay (AUR helper)..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    pushd /tmp/yay
    makepkg -si --noconfirm
    popd
fi

# =========================================
# Arch repo packages
# =========================================
echo ">>> Installing Arch repo packages..."
sudo pacman -S --noconfirm --needed \
    # NVIDIA drivers
    nvidia nvidia-utils nvidia-settings \
    # Display manager
    sddm \
    # Hyprland core
    hyprland xorg-xwayland \
    qt5-wayland qt6-wayland gtk3 gtk4 \
    xdg-desktop-portal-hyprland xdg-desktop-portal-wlr \
    # Networking / audio
    networkmanager network-manager-applet \
    pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber \
    bluez blueman pavucontrol \
    # File management
    thunar thunar-archive-plugin thunar-volman gvfs gvfs-smb \
    tumbler ffmpegthumbnailer \
    # UI/UX + Hyprland extras
    waybar rofi-wayland wl-clipboard clipman \
    grim-hyprland slurp swappy \
    brightnessctl playerctl \
    hyprlock hypridle wleave \
    # Admin
    timeshift timeshift-autosnap \
    # Terminals / TUI tools
    alacritty fastfetch fzf eza fd btop lazydocker

# =========================================
# Enable essential services
# =========================================
echo ">>> Enabling services..."
sudo systemctl enable sddm
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth

# =========================================
# AUR packages with graceful error handling
# =========================================
aur_install() {
    pkg=$1
    if yay -S --noconfirm "$pkg"; then
        echo ">>> $pkg installed successfully."
    else
        echo "⚠️ Warning: Failed to install $pkg. Skipping..."
    fi
}

echo ">>> Installing AUR packages..."
aur_install swayosd
aur_install sysauth
aur_install wayland-bongocat-git

echo
echo ">>> Install complete! 🦙"
echo "Next: run ./scripts/postconfig.sh"
