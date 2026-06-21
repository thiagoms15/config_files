#!/bin/bash

# Background Nvidia updater (every 10s)
(
  while true; do
    nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,memory.used,memory.total \
      --format=csv,noheader,nounits 2>/dev/null | tr -d ' ' > /tmp/i3-nvidia
    sleep 10
  done
) &
NVIDIA_PID=$!

i3status -c /home/thiago/.config/i3/i3status.conf | while read line; do
  if [[ "$line" != *"|||"* ]]; then
    echo "$line"
    continue
  fi

  # Replace unique "|||" separator with tab to split safely
  line_safe="${line//|||/$'\t'}"
  IFS=$'\t' read -ra parts <<< "$line_safe"
  wifi="${parts[0]}"
  eth="${parts[1]}"
  bat="${parts[2]}"
  disk="${parts[3]}"
  load="${parts[4]}"
  mem="${parts[5]}"
  time="${parts[6]}"
  vol="${parts[7]}"

  gpu=""
  if [ -s /tmp/i3-nvidia ]; then
    raw=$(cat /tmp/i3-nvidia)
    temp=$(echo "$raw" | cut -d',' -f1)
    util=$(echo "$raw" | cut -d',' -f2)
    mem_used=$(echo "$raw" | cut -d',' -f3)
    gpu=" | 󰢮 ${temp}°C ${util}% ${mem_used}MiB"
  fi

  echo "${wifi} | ${eth} ||${bat} ||${disk} ||${load}${gpu} | ${mem} ||${time} ||${vol}"
done

kill $NVIDIA_PID 2>/dev/null
