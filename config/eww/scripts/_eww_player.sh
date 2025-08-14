#!/usr/bin/env bash

source scripts/__var.sh

get_media_metadata_json() {
    PLAYER_ART_DEFAULT="$PLAYER_ART_DEFAULT/default.png"
    player_status=$(playerctl status 2>/dev/null)
    local icon=""
    local player_name=""

    if [ "$player_status" = "Playing" ] || [ "$player_status" = "Paused" ]; then
        artist=$(sanitize "$(playerctl metadata artist)" 2>/dev/null)
        title=$(sanitize "$(playerctl metadata title)" 2>/dev/null)
        url=$(sanitize "$(playerctl metadata xesam:url)" 2>/dev/null)
        player_name=$(playerctl metadata --format '{{playerName}}' 2>/dev/null)
        artUrl=$(sanitize "$(playerctl metadata mpris:artUrl)" 2>/dev/null)

        case "$player_name" in
            "spotify")
                icon="$PLAYER_ICON_SPOTIFY"
                PLAYER_ART_DEFAULT="$PLAYER_ART_DEFAULT/spotify.png"
                ;;
            "mpv")
                icon="$PLAYER_ICON_MPV"
                ;;
            *)
                if echo "$url" | grep -q "youtube"; then
                    icon="$PLAYER_ICON_YOUTUBE"
                    PLAYER_ART_DEFAULT="$PLAYER_ART_DEFAULT/youtube.png"
                else
                    icon="$PLAYER_ICON_DEFAULT"
                    PLAYER_ART_DEFAULT="$PLAYER_ART_DEFAULT/default.png"
                fi
                ;;
        esac

        if [ -z "$artist" ]; then
            artist="—"
        fi
        if [ -z "$title" ]; then
            title=""
        fi
        if [ -z "$artUrl" ]; then
            artUrl="$PLAYER_ART_DEFAULT"
        fi

        printf '{"icon": "%s", "artist": "%s", "title": "%s", "artUrl": "%s", "url": "%s", "status": "%s"}' "$icon" "$artist" "$title" "$artUrl" "$url" "$player_status"
    else
        printf '{"icon": "%s", "empty": "%s", "artUrl": "%s"}' "$PLAYER_ICON_DEFAULT" "No media playing right now" "$PLAYER_ART_DEFAULT"
    fi
}

echo "$(get_media_metadata_json)"

playerctl --follow status 2>/dev/null | while read -r _; do
    metadata="$(get_media_metadata_json)"
    echo "$metadata"
    # using sleep because can't load artUrl maybe because of slow internet connection
    if [ "$(echo "$metadata" | jq -r '.artUrl // empty' = "" ]; then
        for i in {1..3}; do
            sleep 3
            metadata="$(get_media_metadata_json)"
            echo "$metadata"
        done
    fi
done