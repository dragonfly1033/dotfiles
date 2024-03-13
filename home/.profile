#!/bin/sh

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc
export PYTHONSTARTUP=$XDG_CONFIG_HOME/python/pythonrc
export LESSHIST=$XDG_STATE_HOME/less/history
export XDG_CONFIG_HOME=$HOME/.config
export ANDROID_HOME=$XDG_DATA_HOME/android
export GNUPGHOME=$XDG_DATA_HOME/gnupg

export EDITOR="micro"
export PAGER="bat -p"
export TERMINAL="alacritty"
export BROWSER="firefox"

export PATH="$HOME/Documents/AndroidStudioProjects/flutter/bin:$HOME/bin:$HOME/.local/bin:$HOME/Games/itchio:$PATH"

export QT_QPA_PLATFORMTHEME=qt5ct
# export QT_STYLE_OVERRIDE=kvantum