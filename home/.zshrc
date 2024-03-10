export PF_INFO="ascii title os kernel pkgs palette"
# pfetch
# colorscript -r
~/gap_rev | awk -F'|' '{print $1"|"$2}' | sed 's/|/|/' | figlet

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# setopt complete_aliases
# fpath+=( ~/.config/zsh )
# autoload -Uz ~/.config/zsh/*

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-auto-notify/auto-notify.plugin.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# autoload -U compinit

[[ -s /home/dragonfly1033/.autojump/etc/profile.d/autojump.sh ]] && source /home/dragonfly1033/.autojump/etc/profile.d/autojump.sh

autoload -U compinit && compinit -u

# autoload -Uz compinit; compinit


export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"

export GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc
export PYTHONSTARTUP=$XDG_CONFIG_HOME/python/pythonrc
export LESSHIST=$XDG_STATE_HOME/less/history
export XDG_CONFIG_HOME=$HOME/.config

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
setopt complete_aliases

export AUTO_NOTIFY_THRESHOLD=20
export AUTO_NOTIFY_TITLE="%command has finished"
export AUTO_NOTIFY_BODY="%elapsed seconds | exit code %exit_code"
export AUTO_NOTIFY_EXPIRE_TIME=10000
AUTO_NOTIFY_IGNORE+=("micro" "m" "man" "less" "bat" "krita" "python")

# start programs from shell but immediately disown them
startAndDisown() {
    $@ & disown
}

mkdirr() {
	/usr/bin/mkdir $1 && cd $1
}

package-list() {
	pacman -Qe | cut -d' ' -f1
}

custom_bat() {
	expanded=$(grep -e "^$1" ~/.config/zsh/file_aliases | cut -d' ' -f2 | sed "s|~|$HOME|")
	bat -p "$1" 2> /dev/null || bat -p "$expanded"	
}

jarvis() {
	gptf -q "$1" | speak
}

gptcode() {
	gptf --code -q "$1" | glow
}




alias d=startAndDisown

bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char
bindkey  "^[[1;5D"  vi-backward-blank-word
bindkey  "^[[1;5C"  vi-forward-blank-word
bindkey  "^H"  backward-delete-word
bindkey  "^[[3;5~"  delete-word
bindkey  "^[[1;5H"  backward-kill-line
bindkey  "^[[1;5F"  kill-line

# export PATH="$HOME/Documents/AndroidStudioProjects/flutter/bin:$HOME/bin:$HOME/Games/itchio:$PATH"
export EDITOR="micro"
export PAGER="bat -p"
export TERMINAL="alacritty"
export BROWSER="firefox"


alias tap='tee /dev/stderr'
alias tb='~/bin/time_brightness'
alias home="cd /mnt/c/Users/shrey"
alias ls='eza --group-directories-first --icons'
alias sl='\ls'
alias l='eza --group-directories-first --icons'
alias s='eza --group-directories-first --icons'
alias la='eza --group-directories-first -lahg --icons'
alias diff='git diff'
alias nano='micro'
alias htop='btop -p 1'
alias tree='tree -a -I .git -I .cache -I .mozilla -I .local -I backups -I pulse -I .vscode-oss -I VSCodium'
alias grep='grep --color=auto'
alias cat='custom_bat'
alias update='sudo pacman -Syyu'
# alias install='sudo pacman -S'
alias install='yay -S $(yay -Sl | sed -r "s|^([^ ]*) ([^ ]*) .*$|\2 \1|" | fzf | cut -d" " -f1)'
# alias uninstall='sudo pacman -Rns'
alias uninstall='yay -Rns $(yay -Qe | sed -r "s/([^ ]*) .*/\1/" | fzf)'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias code='codium'
alias cam='mpv /dev/video0 || mpv /dev/video1'
alias wall='feh --no-fehbg --bg-fill'
alias vedit='avidemux3_qt5'
alias pdf='zathura'
alias windows='sudo mount /dev/nvme0n1p3 /mnt/c'
alias unwindows='sudo umount /dev/nvme0n1p3'
alias rc='micro ~/.zshrc && source ~/.zshrc'
alias m='micro'
alias lc='wc -l'
alias suod='sudo'
alias sd='sudo systemctl'
compdef sd='systemctl'
alias sdu='systemctl --user'
compdef sdu='systemctl'
alias todo="$HOME/bin/note todo"
alias temp="micro /tmp/temp_note"
alias df='df -h'
alias du='du -sh'
alias vlc='mpv'
alias gcl='git clone'
alias ga='git add'
alias gs='git status'
alias gc='git commit -m'
alias gch='git checkout'
alias gpom='git push origin master'
alias clip='xclip -selection clipboard'
alias bc='bc -lq'
alias sudo='sudo EDITOR=micro '
alias gti='git'
compdef gti='git'
alias hist="history 1 -1 | cut -c 8- | sort -r | uniq | fzf | tr -d '\n' | clip"
alias ytdpa='yt-dlp -x --no-flat-playlist --exec after_move:touch'
alias pyvenv='python -m venv venv && source ./venv/bin/activate'
alias gpt='tgpt --provider openai --key "$(cat ~/.ssh/openaikey)" --model "gpt-3.5-turbo" --temperature=0 --top_p=0.75'
alias gptc='tgpt --provider openai --key "$(cat ~/.ssh/openaikey)" --model "gpt-3.5-turbo" --temperature=1 --top_p=0.9'
alias gptf='tgpt --provider openai --key "$(cat ~/.ssh/openaikey)" --model "gpt-3.5-turbo" --temperature=0 --top_p=0.5'
alias speak='~/Documents/piper/piper --model ~/Documents/piper/voices/irish_woman/voice.onnx --sentence_silence 0.1 --output-raw 2>/dev/null | aplay -r 22050 -f S16_LE -t raw - 2>/dev/null'

