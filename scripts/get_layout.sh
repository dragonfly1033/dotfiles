#!/bin/bash

NAME=$(awesome-client "return mouse.screen.selected_tag.layout.name" | grep -o "\".*\"")
if [[ "$NAME" == "\"floating\"" ]]; then
	echo 'A'
elif [[ "$NAME" == "\"tile\"" ]]; then
	echo 'B'
elif [[ "$NAME" == "\"magnifier\"" ]]; then
	echo 'C'
elif [[ "$NAME" == "\"dwindle\"" ]]; then
	echo 'D'
else
	echo "$NAME"
fi
