#!/bin/sh
xrandr --output DSI-1 --rotate right
xrandr --output DSI-2 --rotate right
wlr-randr --output DSI-1 --transform 270
wlr-randr --output DSI-2 --transform 270
exit 0