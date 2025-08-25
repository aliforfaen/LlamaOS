# 🦙 LlamaOS

LlamaOS is a **personal Arch Linux ricing project** — a curated setup for Hyprland tiling Wayland compositing, themed around llamas and minimal computing fun.

- ✅ Based on Arch Linux
- ✅ Hyprland compositor with a modular ecosystem (Waybar, Rofi, Hyprpaper, Hyprlock…)
- ✅ NVIDIA‑ready (RTX driver fixes baked in)
- ✅ English language UI, Norwegian keyboard, Europe/Oslo timezone
- ✅ Timeshift BTRFS snapshots for safe system rollbacks
- ✅ Automated install & post‑config scripts
- ✅ A “Rice Box” backlog to track experiments and artful ricing

---

## 🚀 Quickstart 

Clone:
```bash
git clone https://github.com/<yourusername>/LlamaOS.git
cd LlamaOS
```

1. Run the installer:
   ```bash
   ./scripts/install-packages.sh
   ```
2. Run post‑configuration:
   ```bash
   ./scripts/postconfig.sh
   ```
3. Reboot, log into Hyprland from **SDDM**, and 🎉 welcome to LlamaOS.

---

## 📚 Documentation
- [GUIDE.md](GUIDE.md) – Full install & config instructions.
- [PACKAGES.md](PACKAGES.md) – Curated package list and categories.
- [RICEBOX.md](RICEBOX.md) – Stylistic backlog and ideas.
- `dotfiles/` – Ready‑to‑use Hyprland, Waybar, Rofi configs.

___

## 🔧 Scripts & Commands

LlamaOS ships with several helper scripts:

| Script | Function |
| ------ | -------- |
| `scripts/install-packages.sh` | Installs all core packages (Hyprland, NVIDIA drivers, PipeWire, Thunar, Waybar, Rofi, etc.) + yay (AUR helper). Handles Arch packages with `pacman` and AUR with `yay`. |
| `scripts/postconfig.sh` | Post-install setup: configures timezone (Europe/Oslo), locale (en_US.UTF-8), Norwegian keyboard, and symlinks dotfiles. |
| `scripts/upgrade.sh` | Safe system upgrade: creates a Timeshift snapshot, then runs `yay -Syu`. |
| `scripts/tsm.sh` | Timeshift Snapshot Manager TUI (list/create/restore/delete snapshots using `dialog`). |
| `scripts/switch-config.sh` | Swap between stable `dotfiles/` and experimental configs in `contrib/` using GNU Stow. |

---

## 📜 Daily Commands

- Update system safely:
  ```bash
  ./scripts/upgrade.sh
  ```
- Manage snapshots (TUI):
  ```bash
  ./scripts/tsm.sh
  ```
- Switch to contrib configs:
  ```bash
  ./scripts/switch-config.sh list
  ./scripts/switch-config.sh activate waybar
  ```
- Reset to stable configs:
  ```bash
  ./scripts/switch-config.sh reset
  ```
- System update (manual alternative):
  ```bash
  yay -Syu
  ```
