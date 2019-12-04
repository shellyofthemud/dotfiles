#!/bin/bash

export WLAN=$(ip a | grep -m 1 wlp | cut -f 2 -d " " | sed 's/://')
export ETH=$(ip a | grep -m 1 enp | cut -f 2 -d " " | sed 's/://')

killall -q polybar
while pgrep -x polybar > /dev/null; do sleep 1; done

polybar main &
