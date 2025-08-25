#!/usr/bin/env bash
# =========================================
#  LlamaOS 🦙 Config Switcher
# =========================================
# Swap between stable dotfiles and contrib experiments
# using GNU Stow for easy symlink management.
# -----------------------------------------

## Usage
## List available "sets"
#./scripts/switch-config.sh list

## Activate stable set
#./scripts/switch-config.sh activate dotfiles

## Switch to contrib/waybar experiments
# ./scripts/switch-config.sh activate waybar

## Reset back to stable
# ./scripts/switch-config.sh reset

set -e

CONFIG_DIR="$HOME/.config"
DOTFILES_DIR="$HOME/LlamaOS/dotfiles"
CONTRIB_DIR="$HOME/LlamaOS/contrib"

function usage() {
    echo "Usage:"
    echo "  $0 list                 # show available sets"
    echo "  $0 activate <set>       # activate dotfiles or contrib/<set>"
    echo "  $0 reset                # return to base dotfiles"
    exit 1
}

function deactivate_all() {
    echo ">>> Removing existing symlinks from $CONFIG_DIR (stow unregister)..."
    stow -D -t "$CONFIG_DIR" -d "$DOTFILES_DIR" * || true
    stow -D -t "$CONFIG_DIR" -d "$CONTRIB_DIR" * || true
}

case "$1" in
    list)
        echo "Available sets:"
        echo " - dotfiles (stable)"
        for d in "$CONTRIB_DIR"/*/ ; do
            [ -d "$d" ] && echo " - contrib/$(basename "$d")"
        done
        ;;
    activate)
        [ -z "$2" ] && usage
        deactivate_all
        if [ "$2" == "dotfiles" ]; then
            echo ">>> Activating stable dotfiles..."
            stow -t "$CONFIG_DIR" -d "$DOTFILES_DIR" *
        elif [ -d "$CONTRIB_DIR/$2" ]; then
            echo ">>> Activating contrib set: $2"
            stow -t "$CONFIG_DIR" -d "$CONTRIB_DIR/$2" *
        else
            echo "❌ Error: Set '$2' not found."
            exit 1
        fi
        ;;
    reset)
        deactivate_all
        echo ">>> Reset to stable dotfiles"
        stow -t "$CONFIG_DIR" -d "$DOTFILES_DIR" *
        ;;
    *)
        usage
        ;;
esac

echo ">>> Done."
