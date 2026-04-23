#!/usr/bin/env bash

choice="$(
nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY dev wifi list | \
awk -F: '
!seen[$2]++ {
  ssid=$2; if (ssid=="") ssid="<hidden>";
  marker=($1=="*") ? "*" : " ";
  sec=($4=="" ? "open" : $4);
  printf "%-2s%s (%s%%) [%s]\n", marker, ssid, $3, sec
}' | rofi -dmenu -i -p "Wi-Fi"
)"

[ -z "$choice" ] && exit 0

ssid="$(printf '%s\n' "$choice" | sed -E 's/^[^ ]+ (.*) \([0-9]+%.*$/\1/')"
[ "$ssid" = "<hidden>" ] && exit 0

security="$(nmcli -t -f SSID,SECURITY dev wifi list | awk -F: -v s="$ssid" '$1==s {print $2; exit}')"

if [ -z "$security" ] || [ "$security" = "--" ]; then
    nmcli dev wifi connect "$ssid"
else
    pass="$(rofi -dmenu -password -p "Password for $ssid")"
    [ -n "$pass" ] && nmcli dev wifi connect "$ssid" password "$pass"
fi
