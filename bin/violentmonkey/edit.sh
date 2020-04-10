#!/bin/bash

[[ ! $(command -v http-server) ]] && exit 1
/usr/bin/http-server $HOME/bin/violentmonkey/ -c5
