#!/usr/bin/env bash

choice="$(
    nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY dev wifi list | \
    awk -F: '
    !seen[$2]++ {
        ssid = $2
        if (ssid == "") ssid = "<hidden>"
        marker = ($1 == "*") ? "*" : " "
        sec = ($4 == "" ? "open" : $4)
        printf "%-2s%s (%s%%) [%s]\n", marker, ssid, $3, sec
    }' | rofi -dmenu -i -p "Wi-Fi"
)"

[ -z "$choice" ] && exit 0

ssid="$(
    printf '%s\n' "$choice" | \
    sed -E 's/^[* ]+[[:space:]]*//; s/[[:space:]]+\([0-9]+%\)[[:space:]]+\[.*\]$//'
)"

[ -z "$ssid" ] && exit 0
[ "$ssid" = "<hidden>" ] && exit 0

# If already connected to selected SSID, do nothing.
if nmcli -t -f ACTIVE,SSID dev wifi | grep -Fxq "yes:$ssid"; then
    exit 0
fi

# First try connecting without password.
# This works for already-saved networks.
if nmcli dev wifi connect "$ssid"; then
    exit 0
fi

security="$(
    nmcli -t -f SSID,SECURITY dev wifi list | \
    awk -F: -v s="$ssid" '$1 == s { print $2; exit }'
)"

# If open network, the previous connect should have worked.
# If it failed, just exit.
if [ -z "$security" ] || [ "$security" = "--" ]; then
    exit 1
fi

# New secured network: ask for password.
pass="$(rofi -dmenu -password -p "Password for $ssid")"
[ -z "$pass" ] && exit 0

nmcli dev wifi connect "$ssid" password "$pass"
