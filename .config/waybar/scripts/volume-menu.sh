#!/usr/bin/env bash

current="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')"

choice="$(
printf "100\n75\n50\n25\nmute / unmute\n" | \
rofi -dmenu -p "Volume (${current})"
)"

[ -z "$choice" ] && exit 0

case "$(printf '%s' "$choice" | tr '[:upper:]' '[:lower:]')" in
    "mute / unmute")
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        exit 0
        ;;
esac

if [[ "$choice" =~ ^[0-9]+$ ]]; then
    if [ "$choice" -lt 0 ]; then choice=0; fi
    if [ "$choice" -gt 100 ]; then choice=100; fi

    wpctl set-volume @DEFAULT_AUDIO_SINK@ "${choice}%"

    if [ "$choice" -eq 0 ]; then
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
    else
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
    fi
fi
