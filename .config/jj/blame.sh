#!/bin/sh

help () {
    echo "USAGE: jj blame <search file> <search term> [history search limit]"
    exit 1
}

error () {
    echo "Error: $1"
    exit 1
}

file="$1"
[ -f "$file" ] || help

search="$2"
[ -n "$search" ] || help

limit="$3"
if [ -z "$limit" ]; then
    limit="300"
fi

echo "Finding first occurance in last $limit of $search in $file ..."

for i in $(jj log --no-graph --no-pager -r "ancestors(@,$limit)" -T "change_id++\"\n\"" | tac); do
    if jj file show -r "$i" "$file" | grep "$search"; then
            echo "$i"; break;
    fi
done