#!/bin/sh

if niri msg outputs | grep "HDMI-A-1" > /dev/null; then
    cat ~/.config/niri/config.kdl | grep -E "^workspace" | sed -r 's/workspace "(.*)"/\1/' | while read -r ws; do
        niri msg action focus-workspace "$ws"
        niri msg action move-workspace-to-monitor "HDMI-A-1"
    done
    first=$(cat ~/.config/niri/config.kdl | grep -E "^workspace" | sed -r 's/workspace "(.*)".*/\1/' | head -n 1)
    niri msg action focus-monitor "HDMI-A-1"
    echo "$first"
    niri msg action focus-workspace "$first"
fi