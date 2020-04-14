#!/bin/bash
# This needs python-dbus to work!

# pre-start steps
pacmd suspend true

sleep 10
[ -d $HOME/.jackdrc ] && source $HHOME/.jackdrc
sleep 10
pactl load-module module-jack-sink channels=2
pactl load-module module-jack-source channels=2
pacmd set-default-sink jack_out
pacmd set-default-source jack_in
sleep 10

a2jmidid -e &
