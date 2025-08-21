#!/usr/bin/env bash

max=$(brightnessctl m)
cur=$(brightnessctl g)
screen_pct=$((cur * 100 / max))

if [[ "$1" == "--kbd" ]]; then
    kbd_backlight_device=$(brightnessctl -l | rg kbd_backlight | awk -F"'" '{print $2}' 2>/dev/null)
    if [ -n "$kbd_backlight_device" ]; then
        kbd_backlight_max=$(brightnessctl m -d "$kbd_backlight_device")
        kbd_backlight_cur=$(brightnessctl g -d "$kbd_backlight_device")
        kbd_pct=$((kbd_backlight_cur * 100 / kbd_backlight_max))
        printf '{"screen": %d, "kbd": %d}\n' "$screen_pct" "$kbd_pct"
    fi
else
    printf '{"screen": %d}\n' "$screen_pct"
fi
