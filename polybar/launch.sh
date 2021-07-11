#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch example
polybar example &

my_laptop_external_monitor=$(xrandr --query | grep 'HDMI-0')
if [[ $my_laptop_external_monitor = *connected* ]]; then
    polybar top_external &
fi
echo "Bars launched..."
