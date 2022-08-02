# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ "$(whoami)" = "root" ]] && return

[[ -z "$FUNCNEST" ]] && export FUNCNEST=100 # limits recursive functions, see 'man bash'

## Use the up and down arrow keys for finding a command in history
## (you can write some initial letters of the command first).
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

################################################################################
## Some generally useful functions.
## Consider uncommenting aliases below to start using these functions.

_GeneralCmdCheck() {
  # A helper for functions UpdateArchPackages and UpdateAURPackages.
  echo "$@" >&2
  "$@" || {
    echo "Error: '$*' failed." >&2
      exit 1
    }
  }

  _CheckInternetConnection() {
    # curl --silent --connect-timeout 8 https://8.8.8.8 >/dev/null
    eos-connection-checker
    local result=$?
    test $result -eq 0 || echo "No internet connection!" >&2
    return $result
  }

  _CheckArchNews() {
    local conf=/etc/eos-update-notifier.conf

    if [ -z "$CheckArchNewsForYou" ] && [ -r $conf ]; then
      source $conf
    fi

    if [ "$CheckArchNewsForYou" = "yes" ]; then
      local news="$(yay -Pw)"
      if [ -n "$news" ]; then
        echo "Arch news:" >&2
        echo "$news" >&2
        echo "" >&2
        # read -p "Press ENTER to continue (or Ctrl-C to stop): "
      else
        echo "No Arch news." >&2
      fi
    fi
  }

  UpdateArchPackages() {
    # Updates Arch packages.

    _CheckInternetConnection || return 1

    _CheckArchNews

  #local updates="$(yay -Qu --repo)"
  local updates="$(checkupdates)"
  if [ -n "$updates" ]; then
    echo "Updates from upstream:" >&2
    echo "$updates" | sed 's|^|    |' >&2
    _GeneralCmdCheck sudo pacman -Syu "$@"
    return 0
  else
    echo "No upstream updates." >&2
    return 1
  fi
}

UpdateAURPackages() {
  # Updates AUR packages.

  _CheckInternetConnection || return 1

  local updates
  if [ -x /usr/bin/yay ]; then
    updates="$(yay -Qua)"
    if [ -n "$updates" ]; then
      echo "Updates from AUR:" >&2
      echo "$updates" | sed 's|^|    |' >&2
      _GeneralCmdCheck yay -Syua "$@"
    else
      echo "No AUR updates." >&2
    fi
  else
    echo "Warning: /usr/bin/yay does not exist." >&2
  fi
}

UpdateAllPackages() {
  # Updates all packages in the system.
  # Upstream (i.e. Arch) packages are updated first.
  # If there are Arch updates, you should run
  # this function a second time to update
  # the AUR packages too.

  UpdateArchPackages || UpdateAURPackages
}

######################## Custom ##################################

PS1="\[\e[31m\]\W\[\033[32m\] \$: " # colors for bash info at the beginning
shopt -s autocd                     # Allows you to cd into a directory by just entering it's name

function gc() {
  gcc "$1" -o ~/temp/c_output && ~/temp/c_output
}
source /usr/share/bash-completion/completions/git
source /usr/share/bash-completion/completions/killall
source /usr/share/bash-completion/completions/code-oss
source /usr/share/bash-completion/completions/gcc
source /usr/share/bash-completion/completions/chmod
source /usr/share/bash-completion/completions/chown
source /usr/share/bash-completion/completions/nmcli
source /usr/share/bash-completion/completions/rsync

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

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
export PATH=$HOME/misc/flutter/bin:$PATH

export REACT_EDITOR=code-oss
export EDITOR=vim
export PAGER=less
export HISTFILESIZE=1000
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

# export FLASK_DEBUG=1
proverbQuote.sh # generate a proverb Quote on new shell open
#~/.scripts/meaningDict.sh
# WINE=${WINE:-wine} WINEPREFIX=${WINEPREFIX:-$HOME/.wine} $WINE regedit /tmp/fontsmoothing 2> /dev/null


# alias l='ls -lav --ignore=.?*'   # show long listing but no hidden dotfiles except "."
alias ls='lsd'
# alias l='ls -lav --ignore=.?*' # show long listing but no hidden dotfiles except "."
# alias grep='grep --line-number --with-filename --color=auto'
alias grep='rg'
alias tree='lsd --tree'
# alias ll='ls -lav --ignore=..' # show long listing of all except ".."
alias ll='lsd -lav --ignore-glob=..' # show long listing of all except ".."
alias l='ls'

#alias ls='ls --color=auto -F'
# alias l='ls --color=auto -F'
alias t="tldr"
alias ns="npm start"
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
alias ggpush='git push'
alias gush='git push origin'
alias ggpull='git pull'
alias n='nnn -e'
alias code='code-oss'
# alias r='ranger'
alias v='nvim'
alias vim='nvim'
alias s='cd ~/.scripts && l '
alias cl='cd ~/clg-stuff && nnn -e .'
alias i3config='vim ~/.config/i3/config'
alias glog='git log'
alias ghs='gs'
alias gs='git status'
alias c="cd ~/code && l"
alias startdocker='sudo systemctl start docker.service'
alias z='zathura'
alias sx='sxiv'
alias kpr='kjv Proverbs'
alias hs='firefox --new-tab http://localhost:1313/ & hugo server -D'
alias d="cd ~/.dotfiles && ls -a"
alias ':q'="exit"
alias undo='git reset --soft HEAD~1 && echo "Undid latest commit"'
alias ni='npm i'
alias nutt='neomutt'
alias sql='sudo mysql -u root -p'
alias gcm='git commit -m'
alias gc='git clone'
alias ccode='code . && exit'
alias p8='ping 8.8.8.8'
alias sv='sdcv --use-dict "Oxford Advanced Learner'\''s Dictionary"' # for minimal dictionary searches
alias msql="mycli -u root"
alias lpdf="libreoffice --convert-to pdf"
# alias neovim='nvim'
alias slf='stripe listen --forward-to localhost:3000/api/stripe/stripe-hooks'
alias conky='conky -c ~/.config/conky/.conkyrc'
alias gsoc='cd ~/temp/gsoc && ( firefox "http://localhost:5000/" & npm run start & )'
alias pomodoro='pomodoro.sh'
alias lv='lvim'
alias x='xdg-open'
# alias v='lvim'
alias flc="flutter create" # add folder_path as the next argument
alias cp="cp -v"
alias fs="fs.sh"

alias f="fuck"
alias rm="rmtrash"
alias rmdir="rmdirtrash"
export PROMPT_COMMAND="history -a; history -n" # to sync histories across terminals
alias musicdl="mpsyt"
alias ncp="ncmpcpp"
alias npc="ncmpcpp"
alias graph='git log --all --decorate --oneline --graph'
alias conflict='git diff --name-only --diff-filter=U'

# [[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh

