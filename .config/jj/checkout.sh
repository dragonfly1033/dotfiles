#!/bin/sh

help () {
    echo "USAGE: jj ch <bookmark>"
    exit 1
}

error () {
    echo "Error: $1"
    exit 1
}


query="$1"

echo "[$0] [$1] $query"

bookmark=$(jj bookmark l | cut -d':' -f1 | fzf --cycle --select-1 --query "$query")

[ -n "$bookmark" ] || error "No bookmark selected"

jj edit "$bookmark"