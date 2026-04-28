#!/usr/bin/env bash

while true; do
	bat_lvl=$(cat /sys/class/power_supply/BAT0/capacity)
	if [ "$bat_lvl" -le 15 ]; then
		notify-send -i dialog-error -u critical "Battery low" "Level: ${bat_lvl}%"
		sleep 600
	else
		sleep 120
	fi
done
