#!/usr/bin/env bash

ws=$(hyprctl activeworkspace -j | jq -r '.name')
title=$(hyprctl activewindow -j | jq -r '.title')

print_json() {
  printf '{"current_workspace": "%s", "focused_window_title": "%s"}\n' "$ws" "$title"
}

print_json
sh ~/.config/eww/scripts/_eww_hyprws.sh

socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - |
  stdbuf -o0 awk -F '>>|,' -v ws="$ws" -v title="$title" -e '
    /^activewindow>>/   { title = $3; print_json(); next }
    /^workspace>>/      { ws = $2; print_json(); next }
    /^openwindow>>/     { system("sh ~/.config/eww/scripts/_eww_hyprws.sh"); next }
    /^closewindow>>/    { system("sh ~/.config/eww/scripts/_eww_hyprws.sh"); next }
    /^movewindow>>/     { system("sh ~/.config/eww/scripts/_eww_hyprws.sh"); next }

    function print_json() {
      printf "{\"current_workspace\": \"%s\", \"focused_window_title\": \"%s\"}\n", ws, title
    }
'