#!/bin/bash
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | tail -n1 | awk '{print int($2 * 100)}')
if [ $volume -gt 50 ]; then
    echo "  $volume% "
elif [ $volume -gt 25 ]; then
    echo "  $volume% "
else
    echo "  $volume%"
fi
