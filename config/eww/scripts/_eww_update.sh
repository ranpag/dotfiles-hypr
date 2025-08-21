#!/usr/bin/env bash

installed=$(pacman -Qq | wc -l)
updates=$(checkupdates 2>/dev/null | wc -l)
aur=$(yay -Qua 2>/dev/null | wc -l)
total_updates=$((updates + aur))

if [ "$installed" -eq 0 ]; then
  percent=0
else
  percent=$(( total_updates * 100 / installed ))
fi

printf '{"percent": %d, "total_updates": %d}' "$percent" "$total_updates"