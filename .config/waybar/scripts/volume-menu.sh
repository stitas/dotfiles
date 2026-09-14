#!/usr/bin/env bash

current="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')"

choice="$(
    printf '' | rofi -dmenu -p "Volume (${current}%)"
)"

[ -z "$choice" ] && exit 0

if [[ "$choice" =~ ^[0-9]+$ ]]; then
    if [ "$choice" -gt 150 ]; then choice=150; fi

    wpctl set-volume @DEFAULT_AUDIO_SINK@ "${choice}%"

    if [ "$choice" -eq 0 ]; then
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
    else
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
    fi
fi
