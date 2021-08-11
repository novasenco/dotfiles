#!/bin/bash

# terminate already running bar instances
if pgrep -x 'polybar' >/dev/null; then
	pkill -9 -x 'polybar'
fi

# wait until the processes have been shut down
while pgrep -x 'polybar' >/dev/null; do
	sleep .1
done

for i in $(polybar -m | awk -F: '{print $1}'); do
	MONITOR=$i polybar i3 &
	ln -sf /tmp/polybar_mqueue.$! /tmp/ipc-polybar-i3
	# MONITOR=$i polybar bottom &
	# ln -sf /tmp/polybar_mqueue.$! /tmp/ipc-polybar-bottom
done
