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

check_captive_portal() {
    # Give DHCP/connectivity detection a moment to finish.
    sleep 1

    connectivity="${WIFI_TEST_CONNECTIVITY:-$(nmcli networking connectivity check)}"

    case "$connectivity" in
        portal)
            notify-send "Wi-Fi" "Login required for $ssid"
            xdg-open "http://neverssl.com/" >/dev/null 2>&1 &
            ;;
        full)
            notify-send "Wi-Fi" "Connected to $ssid"
            ;;
        limited)
            notify-send "Wi-Fi" "Connected to $ssid, but Internet access is limited"
            ;;
    esac
}

# Already connected.
if nmcli -t -f ACTIVE,SSID dev wifi | grep -Fxq "yes:$ssid"; then
    check_captive_portal
    exit 0
fi

# Try connecting. Works for open and already-saved networks.
if nmcli dev wifi connect "$ssid"; then
    check_captive_portal
    exit 0
fi

security="$(
    nmcli -t -f SSID,SECURITY dev wifi list | \
    awk -F: -v s="$ssid" '$1 == s { print $2; exit }'
)"

# Open network failed for some other reason.
if [ -z "$security" ] || [ "$security" = "--" ]; then
    notify-send "Wi-Fi" "Failed to connect to $ssid"
    exit 1
fi

# New secured network: ask for password.
pass="$(rofi -dmenu -password -p "Password for $ssid")"
[ -z "$pass" ] && exit 0

if nmcli dev wifi connect "$ssid" password "$pass"; then
    check_captive_portal
else
    notify-send "Wi-Fi" "Failed to connect to $ssid"
    exit 1
fi
