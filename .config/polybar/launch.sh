#!/bin/bash

while polybar-msg cmd quit; do
    polybar-msg cmd quit
done

awerun "
monitors = {}
bar_status = {}
bar_auto = {}

for i = 1,screenO:count() do 
    bar_status[i] = false
    bar_auto[i] = true
end"

for i in $(awerun 'for i, s in ipairs(screenO) do for sn, _ in pairs(s.outputs) do print(sn) end end' | sed '1d;/^$/d;$d'); do
    MONITOR="$i" polybar -r top &
    awesome-client "table.insert(monitors, '$!')"
done