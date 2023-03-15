# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

autoload -U compinit

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"

export GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc
export PYTHONSTARTUP=$XDG_CONFIG_HOME/python/pythonrc
export LESSHIST=$XDG_STATE_HOME/less/history
export XDG_CONFIG_HOME=$HOME/.config
alias xbindkeys='xbindkeys -f $XDG_CONFIG_HOME/xbindkeys/config'

export HISTFILE=$XDG_STATE_HOME/zsh/history
export HISTSIZE=10000
export SAVEHIST=10000
setopt appendhistory
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY

setopt cdablevars
setopt cdsilent
setopt autocd

bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

export PATH="$HOME/bin:$PATH"
export EDITOR="micro"
export TERMINAL="alacritty"
export BROWSER="firefox"

alias home="cd /mnt/c/Users/shrey"
alias sv="cd $HOME/Documents/supervisions"

alias ls='exa --icons'
alias la='exa -lahg --icons'
alias nano='micro'
alias tree='tree -a -I .git -I .cache -I .mozilla -I .local -I backups -I pulse'
alias grep='grep --color=auto'
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias uninstall='sudo pacman -Rns'
alias paint='krita'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias feh='feh -F --slideshow-delay 3 -z'
alias pdf='firefox -P Main --new-window'
alias windows='sudo mount /dev/nvme0n1p3 /mnt/c'
alias unwindows='sudo umount /dev/nvme0n1p3'
alias rc='micro ~/.zshrc'
alias m='micro'
alias suod='sudo'
alias sd='sudo systemctl'
alias todo='micro $HOME/Desktop/todo.md'
alias df='df -h'
alias du='du -sh'
