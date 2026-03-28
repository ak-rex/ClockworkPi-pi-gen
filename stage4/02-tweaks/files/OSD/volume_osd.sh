#!/bin/bash

PERCENT=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%d%% %s\n", $2*100, $3}')
MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c "MUTED")

if [ $MUTED -gt 0 ]
then
  PERCENT="0"
fi

dunstify \
  -h string:x-dunst-stack-tag:osd \
  -h string:bgcolor:#888888ee \
  -h string:hlcolor:#00bbff \
  -h int:value:"$PERCENT" \
  -t 1500 \
  "Volume:"