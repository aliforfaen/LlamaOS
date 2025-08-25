```markdown
# 🦙 LlamaOS Setup Guide 

This guide describes how to install and configure LlamaOS — a customized Arch + Hyprland environment.

---

## 1. Base Install
- Use `archinstall`.
- Filesystem: **BTRFS** with subvols `/@` and `/@home`.
- Bootloader: **GRUB**.
- Hostname: `llamaos`.
- Kernel: `linux` or `linux-lts`.
- Timezone: Europe/Oslo.
- Keyboard: Norwegian.  
- Locale: `en_US.UTF-8`.

⚠️ Do **not** install a DE from the installer — we set it post-install.

---

## 2. Install Packages
Clone repo and run:

```bash
cd ~/LlamaOS/scripts
./install-packages.sh
```

This script:
- Installs **Hyprland, Waybar, Rofi, NVIDIA drivers, Pipewire, File managers**.
- Sets up **yay** as Omarchy-style AUR helper.
- Installs extras: SwayOSD, sysauth, bongocat 🐱.

---

## 3. Post Configuration
Run the helper:

```bash
cd ~/LlamaOS/scripts
./postconfig.sh
```

This will:
- Configure timezone (`Europe/Oslo`).
- Set locale to English (with Norwegian keyboard).
- Symlink dotfiles via `stow`.

---

## 4. Dotfiles
Dotfiles live in `~/LlamaOS/dotfiles/`:
- `hypr/` → Hyprland config (`hyprland.conf`).
- `waybar/` → Bar with clock/network/audio/tray.
- `rofi/` → App launcher config.

Apply with:
```bash
cd ~/LlamaOS/dotfiles
stow -t ~/.config hypr waybar rofi
```

---

## 5. Rice Box
All deferred “styling” projects are tracked in `RICEBOX.md`.

Examples:
- Eww (widgets/bar).
- Fancy SDDM themes.
- Omarchy “Supermenu”.
- Startup splash art.
- Hyprchroma shaders.

---

## 6. Daily Use

- **Terminal**: `Alacritty` (Super+Return).
- **File Manager**: `Thunar` (Super+E).
- **App Launcher**: `Rofi` (Super+D).
- **Screenshot**: Select with `grim-hyprland + slurp`, annotate with `swappy`.
- **Power Menu**: `wleave` (Super+Esc).
- **Updates**:
  ```bash
  yay -Syu
  ```

---

# ✅ Next Steps
After install:
1. Snapshots enabled (Timeshift).
2. Experiment with Hyprspace (workspaces).
3. Pick items from **Rice Box**.
4. Push your config updates to GitHub.
```

---

## 🔧 Git Tracking: Suggested Commits

Here’s a clean commit journey:

```bash
# Initial setup
git add INSTALL.md PACKAGES.md RICEBOX.md .gitignore dotfiles scripts
git commit -m "Initial LlamaOS setup: install plan, packages, ricebox, dotfiles, scripts"

# Add GUIDE.md and PDF
git add GUIDE.md
git commit -m "Add consolidated LlamaOS setup guide"
pandoc GUIDE.md -o GUIDE.pdf
git add GUIDE.pdf
git commit -m "Export setup guide to PDF"

# Push
git push origin main
```
