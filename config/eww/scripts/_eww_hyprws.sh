#!/usr/bin/env bash

ICON_THEME="$(env | grep GTK_ICON_THEME | awk -F '=' '{printf $2}')"
ICON_THEME="${ICON_THEME:-$(grep "gtk-icon-theme-name" ~/.config/gtk-3.0/settings.ini | awk -F '=' '{printf $2}')}"

DESKTOP_PATH=(
  "$HOME/.local/share/applications/"
  "/usr/share/applications/"
)
ICONS_PATH=(
  "$HOME/.local/share/pixmaps/"
  "$HOME/.local/share/icons/$ICON_THEME/"
  "/usr/share/pixmaps/"
  "/usr/share/icons/$ICON_THEME/"
  "/usr/share/icons/"
)
FALLBACK_ICON_PATH="assets/images/fallback-app-icon.png"

find_icon_path() {
  local app_class="$1"
  local initial_class="$2"

  local search_names=(
    "$(echo "$app_class" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')"
    "$(echo "$initial_class" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')"
  )

  local desktop_file=""
  for name in "${search_names[@]}"; do
    for dir in "${DESKTOP_PATH[@]}"; do
      if [[ -f "$dir/${name}.desktop" ]]; then
        desktop_file="$dir/${name}.desktop"
        break 2
      else
        local match=$(grep -l "StartupWMClass=.*$app_class" "$dir"/*.desktop 2>/dev/null)
        if [[ -n "$match" ]]; then
          desktop_file="$match"
          break 2
        fi
      fi
    done
  done

  if [[ -n "$desktop_file" ]]; then
    local icon_val=$(grep -m1 '^Icon=' "$desktop_file" | cut -d'=' -f2-)
    if [[ -n "$icon_val" ]]; then
      if [[ "$icon_val" == /* && -f "$icon_val" ]]; then
        echo "$icon_val"
        return
      else
        for icon_dir in "${ICONS_PATH[@]}"; do
          for ext in png svg xpm jpg jpeg; do
            icon_path_found="$(find $icon_dir -name "*$icon_val*.$ext" 2>/dev/null | head -n 1)"
            if [[ -f "$icon_path_found" ]]; then
              echo "$icon_path_found"
              return
            fi
          done
        done
      fi
    fi
  fi

  echo "$FALLBACK_ICON_PATH"
}

clients_json=$(hyprctl clients -j)
workspaces_json=$(hyprctl workspaces -j)

workspace_list=$(echo "$workspaces_json" | jq -c '.[] | {id, name}')

output="["

for ws in $(echo "$workspace_list" | jq -c '.'); do
  ws_id=$(echo "$ws" | jq '.id')
  ws_name=$(echo "$ws" | jq -r '.name')

  clients=$(echo "$clients_json" | jq -c --argjson id "$ws_id" '
    map(select(.workspace.id == $id)) |
    unique_by(.class) |
    map(select(.class and .class != "")) |
    map({
      class,
      title,
      initialClass,
      initialTitle,
      pid,
      hidden
    }) | .[:2]
  ')

  clients_with_icons=$(echo "$clients" | jq -c '.[]' | while read -r client; do
    class=$(echo "$client" | jq -r '.class')
    initialClass=$(echo "$client" | jq -r '.initialClass')
    icon_path=$(find_icon_path "$class" "$initialClass")
    echo "$client" | jq --arg icon "$icon_path" '. + {iconPath: $icon}'
  done | jq -s '.')

  clients_count=$(echo "$clients_with_icons" | jq 'length')

  output+="{
    \"id\": \"$ws_id\",
    \"name\": \"$ws_name\",
    \"clients_count\": \"$clients_count\",
    \"clients\": $clients_with_icons
  },"
done

output="${output%,}"
output+="]"

output=$(echo "$output" | jq 'sort_by(.id)')

eww update workspaces="$output"