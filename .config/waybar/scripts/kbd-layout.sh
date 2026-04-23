#!/usr/bin/env bash

layout="$(hyprctl devices -j | jq -r '.keyboards[]?.active_keymap' | head -n1)"

case "$layout" in
  *Lithuanian*) echo "LT" ;;
  *English*) echo "EN" ;;
  *) echo "$layout" ;;
esac
