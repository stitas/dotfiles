#!/usr/bin/env bash

choice="$(printf "Lock\nLogout\nSuspend\nReboot\nShutdown\n" | rofi -dmenu -i -p "Power")"
[ -z "$choice" ] && exit 0

confirm() {
    printf "No\nYes\n" | rofi -dmenu -i -p "Confirm $1"
}

case "$choice" in
    Lock)
        loginctl lock-session
        ;;
    Logout)
        [ "$(confirm logout)" = "Yes" ] && hyprctl dispatch exit
        ;;
    Suspend)
        [ "$(confirm suspend)" = "Yes" ] && systemctl suspend
        ;;
    Reboot)
        [ "$(confirm reboot)" = "Yes" ] && systemctl reboot
        ;;
    Shutdown)
        [ "$(confirm shutdown)" = "Yes" ] && systemctl poweroff
        ;;
esac
