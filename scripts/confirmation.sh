#!/bin/bash

OK=$(echo -e "Yes\nNo" | rofi -dmenu -i -p " Are you sure?  ")
if [[ "$OK" == "Yes" ]]; then
	eval "$1"
fi
