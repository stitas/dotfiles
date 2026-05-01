#!/usr/bin/env bash

if grep -qi "closed" /proc/acpi/button/lid/*/state; then
    loginctl lock-session
    sleep 1
    systemctl suspend
fi
