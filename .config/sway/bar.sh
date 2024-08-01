#!/bin/bash

# Google colors
COLORS=("#4285F4" "#DB4437" "#F4B400" "#0F9D58")

# Function to get network status
get_network_status() {
  nmcli device status | grep '^wlan0' | awk '{ print $4 " " $3 }'
}

# Function to get audio volume
get_audio_volume() {
  pamixer --get-volume-human
}

# Function to get screen brightness
get_brightness() {
  brightnessctl | grep 'Current brightness' | awk '{print $4}' | sed 's/.*(\([^)]*\)).*/\1/'
}

# Function to get battery capacity
get_battery_capacity() {
  cat /sys/class/power_supply/BAT$1/capacity
}

# Function to get battery status
get_battery_status() {
  cat /sys/class/power_supply/BAT$1/status
}

# Function to get current date
get_current_date() {
  date +'%d/%m/%y'
}

# Function to get current time
get_current_time() {
  date +'%H:%M'
}

# Initial header for swaybar protocol
echo '{"version": 1}'
echo '['
echo '[],'

# Main loop
while :; do
  network_status=$(get_network_status)
  audio_volume=$(get_audio_volume)
  brightness=$(get_brightness)
  internal_battery_capacity=$(get_battery_capacity 0)
  internal_battery_status=$(get_battery_status 0)
  external_battery_capacity=$(get_battery_capacity 1)
  external_battery_status=$(get_battery_status 1)
  current_date=$(get_current_date)
  current_time=$(get_current_time)

  echo "[
        {\"full_text\": \"$network_status\", \"color\": \"${COLORS[0]}\", \"separator\": true, \"separator_block_width\": 20},
        {\"full_text\": \"Audio $audio_volume\", \"color\": \"${COLORS[1]}\", \"separator\": true, \"separator_block_width\": 20},
        {\"full_text\": \"Bright $brightness\", \"color\": \"${COLORS[2]}\", \"separator\": true, \"separator_block_width\": 20},
        {\"full_text\": \"Bat0 $internal_battery_capacity% ($internal_battery_status)\", \"color\": \"${COLORS[3]}\", \"separator\": true, \"separator_block_width\": 20},
        {\"full_text\": \"Bat1 $external_battery_capacity% ($external_battery_status)\", \"color\": \"${COLORS[0]}\", \"separator\": true, \"separator_block_width\": 20},
        {\"full_text\": \"$current_date\", \"color\": \"${COLORS[1]}\", \"separator\": true, \"separator_block_width\": 20},
        {\"full_text\": \"$current_time\", \"color\": \"${COLORS[2]}\", \"separator\": true, \"separator_block_width\": 20}
    ],"

  sleep 1
done
