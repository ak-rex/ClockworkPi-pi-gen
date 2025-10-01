#!/bin/bash

PERCENT=$(amixer sget Master | grep "Left:" | cut -d "[" -f 2 | cut -d "%" -f 1)
MUTED=$(amixer sget Master | grep -c "off")

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