#!/usr/bin/env bash
# =========================================
#  LlamaOS 🦙 Timeshift Snapshot Manager (TUI)
# =========================================
# Provides a simple ncurses interface for:
# 1. Listing snapshots
# 2. Creating a snapshot
# 3. Restoring a snapshot
# 4. Deleting a snapshot
# -----------------------------------------

print 'Might need to install dialog using sudo pacman -S dialog'

set -e

while true; do
    CHOICE=$(dialog --clear --stdout \
        --title "LlamaOS Timeshift Manager 🦙" \
        --menu "Choose an action:" 15 50 6 \
        1 "List snapshots" \
        2 "Create snapshot" \
        3 "Restore snapshot" \
        4 "Delete snapshot" \
        5 "Exit")

    case $CHOICE in
        1)
            dialog --textbox <(sudo timeshift --list) 20 100
            ;;
        2)
            COMMENT=$(dialog --inputbox "Snapshot comment:" 8 40 "Manual snapshot $(date '+%Y-%m-%d %H:%M')" --stdout)
            sudo timeshift --create --comments "$COMMENT" --tags D
            dialog --msgbox "Snapshot created successfully." 6 40
            ;;
        3)
            SNAP=$(dialog --inputbox "Enter snapshot ID to restore:" 8 40 "" --stdout)
            if dialog --yesno "Restore snapshot $SNAP? This may reboot the system." 7 40; then
                sudo timeshift --restore --snapshot "$SNAP"
            fi
            ;;
        4)
            SNAP=$(dialog --inputbox "Enter snapshot ID to delete:" 8 40 "" --stdout)
            if dialog --yesno "Delete snapshot $SNAP? This cannot be undone." 7 40; then
                sudo timeshift --delete --snapshot "$SNAP"
            fi
            ;;
        5)
            clear
            exit 0
            ;;
    esac
done
