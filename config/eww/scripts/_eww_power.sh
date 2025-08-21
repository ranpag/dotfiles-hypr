#!/usr/bin/env bash

battery_path=$(upower -e | grep -i 'BAT' | head -n 1)
if [ -z "$battery_path" ]; then
    echo '{"error": "Battery device not found"}'
    exit 1
fi
battery_info=$(upower -i "$battery_path")

percentage=$(echo "$battery_info" | grep -E "percentage" | awk '{gsub("%",""); print $2}')
state=$(echo "$battery_info" | grep -E "state" | awk '{print $2}')

# Time to full
time_to_full=$(echo "$battery_info" | grep -i "time to full" | awk '{$1=$2=""; sub(/^ +/, ""); print}')
if [ -z "$time_to_full" ]; then
    time_to_full="N/A"
fi

# Mode scaling governor
if [ -f "/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" ]; then
    mode=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
else
    mode="unknown"
fi


if [ "$state" = "charging" ]; then
    bat_icon="󰂄"
else
    case $percentage in
        [0-9])        bat_icon="󰂃" ;;
        1[0-9])       bat_icon="󰁺" ;;
        2[0-9])       bat_icon="󰁻" ;;
        3[0-9])       bat_icon="󰁼" ;;
        4[0-9])       bat_icon="󰁽" ;;
        5[0-9])       bat_icon="󰁾" ;;
        6[0-9])       bat_icon="󰁿" ;;
        7[0-9])       bat_icon="󰂀" ;;
        8[0-9])       bat_icon="󰂁" ;;
        9[0-9])       bat_icon="󰂂" ;;
        100)          bat_icon="󰁹" ;;
        *)            bat_icon="󰁹" ;;
    esac
fi

case $mode in
    performance)  mode_icon='' ;;
    powersave)    mode_icon='󰌪' ;;
    *)            mode_icon='' ;;
esac



printf '{"bat_icon": "%s", "mode_icon": "%s", "percentage": %d, "state": "%s", "time_to_full": "%s", "mode": "%s"}\n' "$bat_icon" "$mode_icon" "$percentage" "$state" "$time_to_full" "$mode"