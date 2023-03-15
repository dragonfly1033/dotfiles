#!/bin/sh

date | awk -F':' '{print $1" "$2}' | awk -F' ' "{print \$$1}"