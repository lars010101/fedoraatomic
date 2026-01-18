#!/usr/bin/env bash

# Paths (your BAT0)
BAT_PATH="/sys/class/power_supply/BAT0"
STATUS_FILE="$BAT_PATH/status"
CAPACITY_FILE="$BAT_PATH/capacity"

# Thresholds (adjust as you like)
WARNING_LEVEL=20     # yellow/normal urgency
CRITICAL_LEVEL=10    # red/critical urgency

if [[ ! -f "$CAPACITY_FILE" ]]; then
    exit 0
fi

CAPACITY=$(cat "$CAPACITY_FILE")
STATUS=$(cat "$STATUS_FILE")

# Only notify when discharging
if [[ "$STATUS" != "Discharging" ]]; then
    exit 0
fi

if (( CAPACITY <= CRITICAL_LEVEL )); then
    notify-send -u critical \
        "Battery CRITICAL!" \
        "${CAPACITY}% remaining – plug in or save work NOW" \
        -i battery-empty-symbolic \
        -h int:transient:1   # optional: less persistent
elif (( CAPACITY <= WARNING_LEVEL )); then
    notify-send -u normal \
        "Battery low" \
        "${CAPACITY}% remaining" \
        -i battery-low-symbolic
fi
