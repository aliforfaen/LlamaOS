# 🦙 LlamaOS Full Installation Guide

This guide explains how to install **LlamaOS** from scratch:
- Bootable Arch Linux with BTRFS & Timeshift snapshots.
- Hyprland compositor & ecosystem.
- NVIDIA‑ready setup (RTX 3070 tested).
- Automated post‑install with rollback‑friendly snapshots.

---

## 1. Installing Base Arch Linux (with `archinstall`)

Boot into the Arch ISO and run:
```bash
archinstall
```

**Key settings:**
- Disk Layout: `btrfs`
  - Subvolumes: `/@` (root), `/@home` (home).
- Bootloader: `grub`
- Partitions: EFI partition + root (on BTRFS)
- Encryption: OFF (dual boot‑friendly)
- Hostname: `llamaos`
- Kernel: `linux` or `linux-lts` (your choice)
- Skip desktop environment → we’ll add Hyprland later

**Timezone & Locale during install:**
- Timezone: `Europe/Oslo`
- Locale: enable `en_US.UTF-8` in `/etc/locale.gen`

---

## 2. Internet Connectivity

Inside the Arch install or live ISO:

- **Wired network**: usually works automatically.
- **WiFi**:
  ```bash
  iwctl
  station wlan0 scan
  station wlan0 get-networks
  station wlan0 connect SSID
  ```
  Then check with:
  ```bash
  ping archlinux.org
  ```

After install, NetworkManager will manage connections:
```bash
nmcli device wifi list
nmcli device wifi connect "SSID" password "yourpassword"
```

---

## 3. Bootstrap with Scripts

Clone LlamaOS onto your new Arch system:
```bash
git clone https://github.com/<yourusername>/LlamaOS.git
cd LlamaOS/scripts
```

Install all core system packages & yay AUR helper:
```bash
./install-packages.sh
```

- This script installs Hyprland, Waybar, Rofi, NVIDIA drivers, Pipewire, Thunar, Timeshift, and more.
- ✅ All critical services are enabled: SDDM login, NetworkManager, Bluetooth.
- ✅ yay installed for AUR (Omarchy‑style integration).

Then apply locales, timezone, and dotfiles:
```bash
./postconfig.sh
```

- Sets system language → English (US).
- Keyboard → Norwegian.
- Timezone → Europe/Oslo.
- Symlinks configs for `hyprland`, `waybar`, `rofi`.

---

## 4. After First Boot

- At login manager (**SDDM**) select **Hyprland**.
- Try keybinds:
  - `Super+Return` → terminal (Alacritty).
  - `Super+D` → app launcher (Rofi).
  - `Super+E` → Thunar.
  - `Super+Esc` → logout power menu (`wleave`).
- **Waybar** shows clock, network, bluetooth, audio, system tray.
- **Volume & brightness keys** should Just Work™ with SwayOSD.

---

## 5. Error Handling & Rollbacks

### Timeshift Snapshots
LlamaOS uses `timeshift-autosnap`:
- Before each update (`yay -Syu`) → snapshot taken.
- If config or script breaks: boot from GRUB, restore snapshot.

### Script Failures
- Both scripts (`install-packages.sh`, `postconfig.sh`) are written to **exit safely**:
  - If a package fails, install continues without it.
  - If an optional AUR dependency breaks → warning printed, not fatal.
- Example: if `wayland-bongocat-git` fails to build, everything else still installs. You can retry later with:
  ```bash
  yay -S wayland-bongocat-git
  ```

---

## 6. Troubleshooting

- **No internet after install**: run `nmcli device wifi connect`.
- **NVIDIA glitches**: add to `/etc/environment`:
  ```bash
  WLR_NO_HARDWARE_CURSORS=1
  WLR_RENDERER=vulkan
  ```
- **Black screen at login**: check SDDM logs:
  ```bash
  journalctl -u sddm
  ```
- **Locale wrong?** rerun:
  ```bash
  sudo localectl set-locale LANG=en_US.UTF-8
  ```

---

## 7. Post‑Install Ideas (from RICEBOX)

- Fractional scaling (Hyprland `monitor=,preferred,auto,0.9`).
- Fancy SDDM themes (Illamanati branding 🕶🦙).
- ASCII startup headers, terminal fun.
- Extra workspace tools (Hyprspace).
- Notification styling (swaync vs mako).
- BongoCat overlay.

---

# ✅ Summary

Install workflow:
1. Boot with Arch ISO → `archinstall` minimal install with BTRFS + GRUB.
2. Clone LlamaOS repo.
3. Run:
   ```bash
   ./scripts/install-packages.sh
   ./scripts/postconfig.sh
   ```
4. Reboot → login to Hyprland → LlamaOS ready to rice ✨.
