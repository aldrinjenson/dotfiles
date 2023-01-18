# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ "$(whoami)" = "root" ]] && return

[[ -z "$FUNCNEST" ]] && export FUNCNEST=100 # limits recursive functions, see 'man bash'

## Use the up and down arrow keys for finding a command in history
## (you can write some initial letters of the command first).
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

######################## Custom ##################################

PS1="\[\e[31m\]\W\[\033[32m\] \$: " # colors for bash info at the beginning
shopt -s autocd                     # Allows you to cd into a directory by just entering it's name
shopt -s histappend 

function gc() {
  gcc "$1" -o ~/temp/c_output && ~/temp/c_output
}
# source /usr/share/bash-completion/completions/git
# source /usr/share/bash-completion/completions/chown
# source /usr/share/bash-completion/completions/nmcli
# source /usr/share/bash-completion/completions/rsync
# source /usr/share/bash-completion/completions/man

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# set -o vi                #vi mode in bash
bind -x '"\C-l": clear;' # ctrl+l to clear tty

# note that these exports will be considered only when loading bash shell. If you want to add or change exports to reflect in i3 dmenu or something, add them in ~/.profile
# export ANDROID_HOME=/home/aldrin/Android/Sdk
# export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/build-tools/
export PATH=$PATH:$ANDROID_HOME/build-tools/31.0.0
export PATH=$PATH:$ANDROID_HOME/build-tools/33.0.0
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
# export PATH=$HOME/.local/lib/python3.10/site-packages:$PATH
export PATH=$HOME/.local/lib/python3.10/site-packages/graphviz:$PATH
export PATH=$HOME/misc/flutter/bin:$PATH
export PATH=$HOME/code/utils/ai_utilities:$PATH


export REACT_EDITOR=code-oss
export $BROWSER=firefox
export EDITOR=vim
export PAGER=less
export HISTFILESIZE=10000
# # setting unlimited history size
# export HISTFILESIZE=
# export HISTSIZE=
export HISTTIMEFORMAT="%F %T "
# export HISTFILE=~/.bash_eternal_history
export PROMPT_COMMAND="history -a; history -n" # to sync histories across terminals

export NEXT_TELEMETRY_DISABLED=1 # Disable telemetry for nextJs apps
export CHROME_EXECUTABLE=/usr/bin/chromium

function xevf() {
  xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
}

# tabtab source for packages
# uninstall by removing these lines
#[ -f ~/.config/tabtab/__tabtab.bash ] && . ~/.config/tabtab/__tabtab.bash || true

# heroku autocomplete setup
HEROKU_AC_BASH_SETUP_PATH=/home/aldrin/.cache/heroku/autocomplete/bash_setup && test -f $HEROKU_AC_BASH_SETUP_PATH && source $HEROKU_AC_BASH_SETUP_PATH

export NNN_FIFO=/tmp/nnn.fifo
# export NNN_OPENER=/usr/share/nnn/plugins/nuke
# export NNN_OPENER=/home/aldrin/.config/nnn/plugins/nuke
export NNN_BMS='c:~/code;d:~/Desktop;g:~/Clg Stuff'
export NNN_USE_EDITOR=1
export NNN_DE_FILE_MANAGER=thunar
export NNN_PLUG_DEFAULT='1:ipinfo;p:preview-tabbed;o:fzz;'
export NNN_PLUG='p:preview-tabbed;f:finder;d:/home/aldrin/.scripts/drag.sh;x:!chmod +x;g:!git log;w:~/.scripts/wall.sh;c:/home/aldrin/.scripts/nnn-scripts/open-with-code.sh'

# export NNN_PLUG='f:finder;d:/home/aldrin/.scripts/drag.sh;x:!chmod +x;g:!git log;w:~/.scripts/wall.sh;'

export FLASK_DEBUG=1
#~/.scripts/meaningDict.sh
# WINE=${WINE:-wine} WINEPREFIX=${WINEPREFIX:-$HOME/.wine} $WINE regedit /tmp/fontsmoothing 2> /dev/null


# alias l='ls -lav --ignore=.?*'   # show long listing but no hidden dotfiles except "."
alias ls='lsd'
# alias l='ls -lav --ignore=.?*' # show long listing but no hidden dotfiles except "."
# alias grep='grep --line-number --with-filename --color=auto'
alias grep='rg -i'
alias tree='lsd --tree'
# alias ll='ls -lav --ignore=..' # show long listing of all except ".."
alias ll='lsd -lav --ignore-glob=..' # show long listing of all except ".."
alias l='ls'

#alias ls='ls --color=auto -F'
# alias l='ls --color=auto -F'
alias t="tldr"
alias ns="npm start || npx react-scripts start"
alias nd="npm run dev"
alias na="npm run android"
alias p="sudo pacman"
alias ashare='pashare.sh start'
alias bashrc='vim ~/.bashrc'
alias polybarconfig='vim ~/.config/polybar/config.ini'
# alias vimrc='vim ~/.vimrc'
alias vimrc='vim ~/.SpaceVim.d/autoload/myspacevim.vim'
alias scpy='scrcpy -S -w'
alias bluetooth='sudo systemctl start bluetooth && blueman-manager'
alias ccat='highlight -O ansi --force' # alternative to cat with highlight
alias n='nnn -e'
alias code='code-oss'
# alias r='ranger'
alias vim="lvim"
alias v='nvim'
alias vim='nvim'
alias s='cd ~/.scripts && l '
alias cl='cd ~/clg-stuff && nnn -e .'
alias i3config='vim ~/.config/i3/config'

# git commands
alias ggpush='git push'
alias gush='git push origin'
alias ggpull='git pull'
alias gull='git pull'
alias glog='git log'
alias gcl='git clone'
alias ghs='gs'
alias gs='git status'
alias gaa='git add -A'

alias c="cd ~/code && l"
alias startdocker='sudo systemctl start docker.service'
alias z='zathura'
alias sx='sxiv'
alias kpr='kjv Proverbs'
alias hs='firefox --new-tab http://localhost:1313/ & hugo server -D --disableFastRender'
alias d="cd ~/.dotfiles && ls -a"
alias ':q'="exit"
alias undo='git reset --soft HEAD~1 && echo "Undid latest commit"'
alias ni='npm i'
alias nutt='neomutt'
alias sql='sudo mysql -u root -p'
alias gcm='git commit -m'
alias gc='git clone'
alias ccode='code . && exit'
alias p8='ping gnu.org'
alias sv='sdcv --use-dict "Oxford Advanced Learner'\''s Dictionary"' # for minimal dictionary searches
# alias msql="mycli -u root"
alias msql="mycli -u aldrin"
alias lpdf="libreoffice --convert-to pdf"
# alias neovim='nvim'
# alias slf='stripe listen --forward-to localhost:3000/api/stripe/stripe-hooks'
alias conky='conky -c ~/.config/conky/.conkyrc'
alias gsoc='cd ~/temp/gsoc && ( firefox "http://localhost:5000/" & npm run start & )'
alias pomodoro='pomodoro.sh'
alias lv='lvim'
alias x='xdg-open'
alias v='lvim'
alias flc="flutter create" # add folder_path as the next argument
alias cp="cp -v"
alias fs="fs.sh" # search all custom scripts and open them with vim

alias f="fuck"
alias rmr="rm" # use normal rm with rmr
alias rm="rmtrash" # to delete to trash instead of permanenet deletion with rm
alias rmdir="rmdirtrash"
# alias musicdl="mpsyt"
alias musicdl="yt"
alias ncp="ncmpcpp"
alias npc="ncmpcpp"
alias graph='git log --all --decorate --oneline --graph'
alias conflict='git diff --name-only --diff-filter=U'
alias b="cd ~/code/my-blog && ls"
alias muttrc="vim ~/.muttrc"
alias wl="ls -l | wc -l"
alias disableNine="xmodmap -e 'keycode 18='"
alias jupiterStart="jupyter-notebook /home/aldrin/code/learn/fastbook"
alias "..."="cd ../../"
# alias jpgToJpeg = "mogrify -auto-orient -format jpeg *.jpg && rm *.jpg" # for ML/DA
# source /usr/share/nvm/init-nvm.sh
# proverbQuote.sh # generate a proverb Quote on new shell open

alias sch="saveCommandToHistory.sh"
alias vim="lvim"
alias phone="mirrorPhone.sh || scrcpy -S -w"
alias fixmouse="sudo fixMouse.sh"
alias fixwifi="sudo fixWifi.sh"
alias sourcebash="source ~/.bashrc"
set -o vi
# alias fixkeyboard="setxkbmap -layout us -variant ,qwerty"
alias startpixel="emulator -avd Resizable_API_33"
alias vi="vim"
alias flaskstart="flask --app app.py --debug run"
alias connectHDMI="xrandr --output HDMI2 --mode 1920x1080 --rate 60"
alias sharescreen="xrandr --output HDMI2 --mode 1920x1080 --rate 60"
alias dox="cd ~/Documents"
alias lsf='xdg-open "$(ls | fzf)"'
alias fd="find . -iname"
alias locate="locate -i"
# bind 'set show-all-if-ambiguous on'
# bind 'TAB:menu-complete'
alias fixrapoo="xinput --set-prop 19 'libinput Natural Scrolling Enabled' 0"
alias compressVideo="ffmpeg -i Demo.mp4 -vcodec libx265 -crf 28 output.mp4"
# [[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh
alias docker="sudo docker"
alias shpie='ssh pi@100.107.113.33'

# echo "Proverbs 22:4 True Humility and Fear of the Lord, lead to Riches, Honor and Long Life"
alias ec2ip="firefox http://3.109.122.203"
alias :wq="exit"
alias compersImg="optipng"
alias whatIsMyPublicIp="curl ipinfo.io/ip"
alias ce="cd ~/code/learn/ethical-stuff && ls"
alias cw="cd ~/code/work && ls"
alias ci="cd ~/code/work/iedc && ls"
# echo "You can do better than laze around!"
alias evillimiter="sudo evillimiter"
alias systemctl="sudo systemctl"

export PATH="/home/aldrin/.deta/bin:$PATH"
