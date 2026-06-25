#!/bin/sh

help () {
    echo "USAGE: jj push"
    exit 1
}

error () {
    echo "Error: $1"
    exit 1
}

here=$(pwd)

if ! [ -f "$here/.git/hooks/pre-commit" ]; then
    error "No pre-commit hook in $here/.git/hooks/pre-commit"
fi

if ! [ -f "$here/.git/hooks/post-commit" ]; then
    error "No post-commit hook in $here/.git/hooks/post-commit"
fi

if [ "$1" = "skip" ]; then
    shift 1
    jj git push "$@"
    exit 0
else
    if ! "$here"/.git/hooks/pre-commit; then
        error "Pre commit hooks failed"
    fi

    jj git push "$@"

    if ! "$here"/.git/hooks/post-commit; then
        error "Post commit hooks failed"
    fi
fi

