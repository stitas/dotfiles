#!/usr/bin/env bash

set -eu

# Check if ran in sudo mode
if [ "$EUID" -ne 0 ]; then
	echo "Script has to be ran in sudo mode"
	exit 1
fi

HOSTS_FILE="/etc/hosts"
HOST="0.0.0.0"
YOUTUBE_LINE="$HOST youtube.com"
REDDIT_LINE="$HOST reddit.com"
LINES=("$YOUTUBE_LINE" "$REDDIT_LINE")

for line in "${LINES[@]}"
do
	if rg -qF "$line" "$HOSTS_FILE"; then
		rg -vxF "$line" /etc/hosts > temp.txt &&  mv temp.txt /etc/hosts # Remove line from hosts file
	else
		echo "$line" | tee -a "$HOSTS_FILE" # Append line to the end
	fi	
done
