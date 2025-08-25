# LlamaOS Installation Plan 🦙

## Base Install (via `archinstall`)
- Select `btrfs` filesystem.
- Create subvolumes: `/@` (root), `/@home` (home).
- Encryption: OFF (dual boot friendly).
- Bootloader: GRUB.
- Kernel: linux (or linux-lts).
- Hostname: `llamaos`.
- Environment/DE: **Do not select** — install base only.

## Post-Install: Core Setup

```bash
sudo pacman -Syu

# NVIDIA
sudo pacman -S nvidia nvidia-utils nvidia-settings

# Display manager
sudo pacman -S sddm
sudo systemctl enable sddm

# Hyprland + Wayland deps
sudo pacman -S hyprland xorg-xwayland qt5-wayland qt6-wayland \
  gtk3 gtk4 xdg-desktop-portal-hyprland

# Networking / Sound
sudo pacman -S networkmanager network-manager-applet \
  pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber \
  blueman pavucontrol

# File manager
sudo pacman -S thunar thunar-archive-plugin thunar-volman gvfs \
  gvfs-smb ffmpegthumbnailer tumbler

# System utilities
sudo pacman -S waybar rofi-wayland wl-clipboard clipman \
  grim-hyprland slurp swappy brightnessctl playerctl \
  hyprlock hypridle

# Extras
paru -S swayosd sysauth wayland-bongocat-git

## NVIDIA Bootloader Fix
Add to `/etc/default/grub`:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet nvidia_drm.modeset=1 nvidia_drm.fbdev=1"
```

Then:
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Also update `mkinitcpio.conf`:
```
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```
then regenerate with 
```bash
sudo mkinitcpio -P
```

## Timeshift (Snapshots)
```bash
sudo pacman -S timeshift timeshift-autosnap
```

## Post-Install TODO
- Fractional scaling.
- Styling (plymouth, startup effects, screensaver).
- Dotfile management via `stow`.
- Testing Hyprspace workspaces.
```
