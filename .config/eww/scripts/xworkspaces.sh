#!/bin/sh

val=$(awesome-client '
local awful = require("awful")
local ret = ""
for i, v in ipairs(awful.screen.focused().tags)
do
local swi = "./bin/switch.sh "..tostring(i)
if v == awful.screen.focused().selected_tag then ret = ret .. "(button :class \"ws\" :onclick \"" .. swi .."\" \"\")"
elseif #v:clients() >= 1 then ret = ret .. "(button :class \"ws\" :onclick \"" .. swi .."\" \"綠\")"
else ret = ret .. "(button :class \"ws\" :onclick \"" .. swi .."\" \"祿\")"
end
end
return ret' | awk -F'string "' '{print $2}' | awk -F')"' '{print $1")"}')
echo "(box :orientation \"v\" $val)"