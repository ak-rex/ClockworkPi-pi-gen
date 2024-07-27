#!/bin/bash

CURRENT=$(brightnessctl g)
MAX=$(brightnessctl m)

PERCENT=$((100*$CURRENT/$MAX))

dunstify \
-h string:x-dunst-stack-tag:osd \
-h string:bgcolor:#888888cc \
-h string:hlcolor:#00bbff \
-h int:value:"$PERCENT" \
-t 1500 \
"Brightness:"