#!/usr/bin/env bash

sleep 2

HDMI_STATUS="/sys/class/drm/card0-HDMI-A-1/status"
PREV_STATE="unknown"

while true; do
    if [ -f "$HDMI_STATUS" ]; then
        CURRENT_STATE=$(cat "$HDMI_STATUS")

        if [ "$CURRENT_STATE" != "$PREV_STATE" ]; then
            if [ "$CURRENT_STATE" = "connected" ]; then
                niri msg output eDP-1 off
                sleep 0.5
                notify-send -u normal -i display "Monitor Esterno" "HDMI-A-1 collegato. eDP-1 disattivato."
            else
                niri msg output eDP-1 on
                sleep 0.5
                notify-send -u normal -i display "Monitor Esterno" "HDMI-A-1 scollegato. eDP-1 attivato."
            fi
            PREV_STATE="$CURRENT_STATE"
        fi
    fi
    sleep 2
done
