#!/usr/bin/env bash

powered="$(bluetoothctl show | awk '/Powered:/ {print $2}')"

if [ "$powered" != "yes" ]; then
    choice="$(printf "Enable Bluetooth\n" | rofi -dmenu -p "Bluetooth")"
    [ "$choice" = "Enable Bluetooth" ] && bluetoothctl power on
    exit 0
fi

devices="$(bluetoothctl devices | sed 's/^Device //')"

choice="$(
{
  printf "Disable Bluetooth\n"
  printf "Scan for devices\n"
  printf "%s\n" "$devices"
} | rofi -dmenu -i -p "Bluetooth"
)"

case "$choice" in
  "Disable Bluetooth")
    bluetoothctl power off
    ;;
  "Scan for devices")
    bluetoothctl --timeout 5 scan on >/dev/null 2>&1
    ;;
  "")
    exit 0
    ;;
  *)
    mac="${choice%% *}"
    info="$(bluetoothctl info "$mac")"
    if printf '%s\n' "$info" | grep -q "Connected: yes"; then
        bluetoothctl disconnect "$mac"
    else
        bluetoothctl connect "$mac"
    fi
    ;;
esac
