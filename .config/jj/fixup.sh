#!/bin/sh

help () {
    echo "USAGE: jj fixup <change id>"
    echo "  <change id> must be a revset that yields exactly 1 change"
    exit 1
}

error () {
    echo "Error: $1"
    exit 1
}


change="$1"

[ -n "$change" ] || help

count=$(jj log -T "desc" -r "$change" | grep -c "{:@:}")

[ "$count" -eq 1 ] || help

desc=$(jj log -T "desc" -r "$change" | head -n 1 | sed -r 's/^.*\{:@:\}[a-z]+, (.*)$/\1/')

[ -n "$desc" ] || error "Description of $change is empty"

jj new -m "fixup! $desc" -A "$change" 