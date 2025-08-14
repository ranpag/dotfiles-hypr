#!/usr/bin/env bash

source scripts/__var.sh

# --- WiFi ---
wifi_state="unavailable"
ssid=""
wifi_icon="$WIFI_UNAVAILABLE"
if nmcli -t -f TYPE,STATE device | grep -q "^wifi:connected$"; then
    wifi_state="connected"
    wifi_icon="$WIFI_CONNECTED"
    ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes:' | cut -d':' -f2)
elif nmcli -t -f TYPE,STATE device | grep -q "^wifi:disconnected$"; then
    wifi_state="disconnected"
    wifi_icon="$WIFI_DISCONNECTED"
fi


# --- Bluetooth ---
is_bluetooth_daemon_active=false
is_bluetooth_connected=false
connected_device=""
bluetooth_icon="$BLUETOOTH_UNAVAILABLE"
if systemctl status bluetooth &>/dev/null; then
    is_bluetooth_daemon_active=true
    bluetooth_icon="$BLUETOOTH_ACTIVE"
    if bluetoothctl show | grep -q "Powered: yes"; then
        device_line=$(bluetoothctl devices Connected | head -n 1)
        if [ -n "$device_line" ]; then
            is_bluetooth_connected=true
            connected_device=$(echo "$device_line" | cut -d' ' -f3-)
            bluetooth_icon="$BLUETOOTH_CONNECTED"
        fi
    fi
fi


# --- Tethering (Hotspot) ---
is_tethering_active=false
tethering_icon="$TETHERING_UNAVAILABLE"
if nmcli device | grep -q "ap *connected"; then
    is_tethering_active=true
    tethering_icon="$TETHERING_ACTIVE"
fi


# --- VPN (WireGuard only, no sudo) ---
# Note: make sure filename conf wireguard interface is started with wg
is_vpn_active=false
vpn_interface=""
vpn_icon="$VPN_UNAVAILABLE"
for iface in $(ip -o link show | awk -F': ' '{print $2}'); do
    if echo "$iface" | grep -q '^wg'; then
        if ip link show "$iface" | grep -q "state UP"; then
            is_vpn_active=true
            vpn_interface="$iface"
            vpn_icon="$VPN_CONNECTED"
            break
        fi
    fi
done


# --- Ethernet ---
is_eth_connected=false
eth_icon="$ETH_UNAVAILABLE"
if nmcli -t -f TYPE,STATE device | grep -q "^ethernet:connected$"; then
    is_eth_connected=true
    eth_icon="$ETH_CONNECTED"
fi


# --- Output JSON for Eww ---
printf '{
  "wifi_state": "%s",
  "wifi_icon": "%s",
  "ssid": "%s",
  "is_bluetooth_daemon_active": %s,
  "is_bluetooth_connected": %s,
  "bluetooth_icon": "%s",
  "connected_device": "%s",
  "is_tethering_active": %s,
  "tethering_icon": "%s",
  "is_vpn_active": %s,
  "vpn_icon": "%s",
  "vpn_interface": "%s",
  "is_eth_connected": %s,
  "eth_icon": "%s"
}\n' \
  "$wifi_state" \
  "$wifi_icon" \
  "$ssid" \
  "$is_bluetooth_daemon_active" \
  "$is_bluetooth_connected" \
  "$bluetooth_icon" \
  "$connected_device" \
  "$is_tethering_active" \
  "$tethering_icon" \
  "$is_vpn_active" \
  "$vpn_icon" \
  "$vpn_interface" \
  "$is_eth_connected" \
  "$eth_icon" 
