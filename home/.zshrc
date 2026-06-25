# zmodload zsh/zprof

export PF_INFO="ascii title os kernel pkgs palette"
# pfetch
# colorscript -r
# ~/gap_rev

autoload -Uz compinit 
if [[ -n ${XDG_CACHE_HOME}/zsh/.zcompdump(#qN.mh+24) ]]; then
	compinit -d "${XDG_CACHE_HOME}/zsh/.zcompdump";
else
	compinit -C -d "${XDG_CACHE_HOME}/zsh/.zcompdump";
fi


source <(jj util completion zsh) 
compdef _jj jj

export STARSHIP_CONFIG=~/.config/starship/starship.toml

TRANSIENT_PROMPT_TRANSIENT_PROMPT='$(/usr/bin/starship prompt --profile=transient --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'
TRANSIENT_PROMPT__PROMPT='$(/usr/bin/starship prompt --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'

eval "$(starship init zsh)"
source /home/dragonfly1033/.config/zsh/transient-prompt.zsh-theme

eval "$(fzf --zsh)"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-auto-notify/auto-notify.plugin.zsh

[[ -s /home/dragonfly1033/.autojump/etc/profile.d/autojump.sh ]] && source /home/dragonfly1033/.autojump/etc/profile.d/autojump.sh

export AUTO_NOTIFY_THRESHOLD=20
export AUTO_NOTIFY_TITLE="%command has finished"
export AUTO_NOTIFY_BODY="%elapsed seconds | exit code %exit_code"
export AUTO_NOTIFY_EXPIRE_TIME=10000
AUTO_NOTIFY_IGNORE+=("micro" "m" "man" "less" "bat" "krita" "python")

export HISTFILE=$XDG_STATE_HOME/zsh/history
export HISTSIZE=10000
export SAVEHIST=10000
setopt appendhistory
setopt hist_ignore_all_dups
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY
setopt EXTENDED_GLOB
setopt cdablevars
setopt cdsilent
setopt autocd
setopt complete_aliases

mkdirr() {
	/usr/bin/mkdir $1 && cd $1
}

cinfo() {
	whatis $1
	which $1
}

tmp () {
    ~/bin/tmpfile
    cd /tmp
}

prog () {
    progress -m -p "$(pgrep $1 | fzf -1)"
}

yt () {
    xclip -o -selection clipboard | sed -r 's/yew/you/' | xargs -I {} mpv "{}"
}

phone () {
    aft-mtp-mount ~/Desktop/phone
    cd ~/Desktop/phone
}


bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char
bindkey  "^[[1;5D"  vi-backward-blank-word
bindkey  "^[[1;5C"  vi-forward-blank-word
bindkey  "\u001bcontrolback"  backward-delete-word
bindkey  "^[[3;5~"  delete-word
bindkey  "^[[1;5H"  backward-kill-line
bindkey  "^[[1;5F"  kill-line


select_jj_change () {
    if ! jj st 1>/dev/null 2>/dev/null ; then 
        return 0;
    fi
    jj log --color always | tac | sed "1d" | fzf --ansi --cycle --bind 'down:down+down+down' --bind 'up:up+up+up' --bind 'load:last' | sed -r 's/^[^a-z]* ([a-z]+) .*/\1/' | tr -d '\n' | xdotool type -f -
}
zle -N select_jj_change
bindkey  "^F" select_jj_change

alias cdc='cd "$OLDPWD"'
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
alias htop='btop'
alias tree='tree -a -I .git -I .cache -I .mozilla -I .local -I backups -I pulse -I .vscode-oss -I VSCodium'
alias grep='grep --color=auto'
alias cat='bat -p'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias find='find -L'
alias cam='mpv /dev/video0 || mpv /dev/video1'
alias pdf='find . -maxdepth 1 -type f -name "*.pdf" | fzf -1 | xargs -I {} zathura {}'
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
alias temp="/bin/rm $HOME/.config/micro/backups/%tmp%tmp; micro /tmp/tmp"
alias du='du -sh'
alias vlc='mpv'
alias gcl='git clone'
alias ga='git add'
alias gs='git status'
alias gc='git commit -m'
alias gch='git checkout'
alias gq='git rebase -i HEAD~2'
alias gp='git push origin'
alias bc='bc -lq'
alias sudo='sudo EDITOR=micro '
alias gti='git'
compdef gti='git'
alias hist="history 1 -1 | cut -c 8- | fzf --tac | tr -d '\n' | tap | clip"
alias ytdpa='yt-dlp -x --no-flat-playlist --exec after_move:touch'
alias ytdpaf='yt-dlp -x --no-flat-playlist --exec after_move:touch -a'
alias pyvenv='python -m venv venv && source ./venv/bin/activate'
alias speak='~/Documents/piper/piper --model ~/Documents/piper/voices/irish_woman/voice.onnx --sentence_silence 0.1 --output-raw 2>/dev/null | aplay -r 22050 -f S16_LE -t raw - 2>/dev/null'
alias scrcpy='scrcpy -S'
alias whatismyip='curl "ifconfig.me"'
alias cdusb='cd `usb go`'
alias incog='unset HISTFILE; sed "$d" -i ~/.local/state/zsh/history'
alias mount='mount -o uid=1000'
alias ascii='figlet'
alias pl='swipl'
alias pdfjoin='pdfunite'
alias df='dysk -u binary'
alias codecd='code . -r'
alias pwdc='pwd | xargs -I {} printf "\"{}\"" | clip'
alias start='alacritty --class "term-spawned" & disown'
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    alias wall='feh --no-fehbg --bg-fill'
    alias clip='wl-copy'
    alias code='codium'
else
    alias wall='swaybg -i'
    alias clip='xclip -r -selection clipboard'
    alias code='codium --enable-features=UseOzonePlatform --ozone-platform=wayland'
    alias feh='imv'
fi


eval "$(direnv hook zsh)"

eval "$(niri completions zsh)"
