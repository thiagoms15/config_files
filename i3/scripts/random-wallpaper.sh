#!/bin/sh
wallpaper="$(find /home/thiago/Pictures -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | shuf -n 1)"
[ -n "$wallpaper" ] && feh --bg-fill "$wallpaper"
