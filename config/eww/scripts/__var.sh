#!/usr/bin/env bash

source styles/colors.sh
source scripts/__helper.sh

# NETINFO
WIFI_UNAVAILABLE="󰤭"
WIFI_DISCONNECTED="󰤯"
WIFI_CONNECTED="󰤟"
WIFI_CONNECTED2="󰤢"
WIFI_CONNECTED3="󰤥"
WIFI_CONNECTED4="󰤨"
BLUETOOTH_UNAVAILABLE="󰂲"
BLUETOOTH_ACTIVE="󰂯"
BLUETOOTH_CONNECTED="󰂱"
TETHERING_UNAVAILABLE=" "
TETHERING_ACTIVE=" "
TETHERING_CONNECTED=""
VPN_UNAVAILABLE="󰇨"
VPN_CONNECTED=""
ETH_UNAVAILABLE="󰶐"
ETH_CONNECTED="󰍹"

# PLAYER
PLAYER_ICON_SPOTIFY=" "
PLAYER_ICON_YOUTUBE=" "
PLAYER_ICON_MPV=" "
PLAYER_ICON_DEFAULT="󰎇 "
PLAYER_ART_DEFAULT="assets/images/fallback-player-art"

# WEATHER
WEATHER_ICONS='{
    "0": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Clear Sky"
    },
    "1": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Mainly Clear"
    },
    "2": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Partly Cloud"
    },
    "3": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Overcast"
    },
    "45": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Fog"
    },
    "48": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Rime Fog"
    },
    "51": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Drizzle Light"
    },
    "53": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Drizzle Moderate"
    },
    "55": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Drizzle Dense"
    },
    "56": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Frezzing Drizzle Light"
    },
    "57": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Frezzing Drizzle Dense"
    },
    "61": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Rain Slight"
    },
    "63": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Rain Moderate"
    },
    "65": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Rain Heavy"
    },
    "66": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Frezzing Rain Light"
    },
    "67": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Frezzing Rain Heavy"
    },
    "71": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Snow Fall Slight"
    },
    "73": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Snow Fall Moderate"
    },
    "75": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Snow Fall Heavy"
    },
    "77": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Snow Grains"
    },
    "80": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Rain Shower Slight"
    },
    "81": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Rain Showwer Moderate"
    },
    "82": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Rain Shower Violent"
    },
    "85": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Snow Shower Slight"
    },
    "86": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Snow Shower Heavy"
    },
    "95": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Thunderstorm Slight"
    },
    "96": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Thunderstorm Moderate"
    },
    "99": {
        "icon": "",
        "day_icon": "",
        "night_icon": "",
        "desc": "Thunderstorm Heavy"
    }
}'