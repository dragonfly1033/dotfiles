#!/bin/sh

help () {
    echo "USAGE: jj sync"
    exit 1
}

error () {
    echo "Error: $1"
    exit 1
}

jj git fetch
jj rebase -s "(master+) & (master..bookmarks())" -d "master@origin"
jj bookmark set -r "master@origin" main