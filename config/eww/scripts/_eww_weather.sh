#!/usr/bin/env bash

source scripts/__var.sh

LATITUDE="51.5085"
LONGITUDE="-0.1257"
URL="https://api.open-meteo.com/v1/forecast"
CURRENT_VARS="temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,rain,showers,snowfall,weather_code,cloud_cover,pressure_msl,surface_pressure,wind_gusts_10m,wind_direction_10m,wind_speed_10m"
API_URL="${URL}?latitude=${LATITUDE}&longitude=${LONGITUDE}&current=${CURRENT_VARS}&timezone=auto&forecast_days=1&forecast_hours=1&past_hours=1"
API_RESPONSE=$(curl -s "$API_URL")

if [ $? -ne 0 ]; then
    echo "Error: Cant get info from API."
    exit 1
fi

weather_code=$(echo "$API_RESPONSE" | jq '.current.weather_code')

if [ -n "$weather_code" ]; then
    weather_alt=$(echo "$WEATHER_ICONS" | jq -c --argjson wc "\"$weather_code\"" '.[$wc]')
    weather_data=$(echo "$API_RESPONSE" | jq -c --argjson wa "$weather_alt" '.current.weather_alt = $wa' )
    weather=$(echo "$weather_data" | jq '.isloading = false' )
fi

echo "${weather:-$API_RESPONSE}"
