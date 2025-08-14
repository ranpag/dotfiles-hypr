#!/usr/bin/env bash

ICON_HEADPHONES="󰋋"
HEADPHONES_MUTED='<span color=\"#6d404d\">󰟎</span>'
ICON_LOW="󰕿"     
ICON_MED="󰖀"    
ICON_HIGH="󰕾"   
ICON_MUTED='<span color=\"#6d404d\">󰖁</span>'
MIC_MUTED='<span color=\"#6d404d\"> </span>'
MIC_ICON=""  

audio_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
mic_info=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)

audio_vol=$(echo "$audio_info" | awk '{ print int($2 * 100) }')
mic_vol=$(echo "$mic_info" | awk '{ print int($2 * 100) }')

audio_muted=$(echo "$audio_info" | grep -q MUTED && echo true || echo false)
mic_muted=$(echo "$mic_info" | grep -q MUTED && echo true || echo false)

active_port=$(pactl list sinks | grep -A10 'Active Port' | grep 'Active Port' | awk '{print $3}')

if echo "$active_port" | grep -qi 'headphones\|headset'; then
    audio_icon="$ICON_HEADPHONES"
    if [ "$audio_muted" = true ]; then
        audio_icon="$HEADPHONES_MUTED"
    fi
elif [ "$audio_muted" = true ]; then
    audio_icon="$ICON_MUTED"
else
    if [ "$audio_vol" -gt 60 ]; then
        audio_icon="$ICON_HIGH"
    elif [ "$audio_vol" -gt 30 ]; then
        audio_icon="$ICON_MED"
    else
        audio_icon="$ICON_LOW"
    fi
fi

if [ "$mic_muted" = true ]; then
    mic_icon="$MIC_MUTED"
else
    mic_icon="$MIC_ICON"
fi

printf '{"mic": %d, "audio": %d, "audio_icon": "%s", "mic_icon": "%s", "audio_mute": %s, "mic_mute": %s, "output_type": "%s"}\n' \
  "$mic_vol" "$audio_vol" "$audio_icon" "$mic_icon" "$audio_muted" "$mic_muted" "$(echo "$active_port" | sed "s/-/ /g" | awk '{print $3}')"
