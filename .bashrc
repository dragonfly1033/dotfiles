#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH="$HOME/bin:$PATH"
export EDITOR="micro"
export TERMINAL="alacritty"
export BROWSER="firefox"

alias ls='exa'
alias nano='micro'
alias tree='tree -a -I .git'

PS1='\[\e[0;37m\]┌─── \[\e[0;38;5;31m\]\w \[\e[0;32m\]$(git branch 2>/dev/null | grep '"'"'^*'"'"' | colrm 1 2)\n\[\e[0;37m\]└───\[\e[0;38;5;167m\]\$\[\e[0;1;38;5;221m\]> \[\e[0m\]'

