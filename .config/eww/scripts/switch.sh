#!/bin/sh

num=$1

awesome-client "
local awful = require(\"awful\")
awful.screen.focused().tags[$num]:view_only()
"
