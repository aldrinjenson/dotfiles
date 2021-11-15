# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -f ~/.welcome_screen ]] && . ~/.welcome_screen

_set_my_PS1() {
    PS1='[\u@\h \W]\$ '
    if [ "$(whoami)" = "liveuser" ] ; then
        local iso_version="$(grep ^VERSION= /usr/lib/endeavouros-release 2>/dev/null | cut -d '=' -f 2)"
        if [ -n "$iso_version" ] ; then
            local prefix="eos-"
            local iso_info="$prefix$iso_version"
            PS1="[\u@$iso_info \W]\$ "
        fi
    fi
}
_set_my_PS1
unset -f _set_my_PS1

ShowInstallerIsoInfo() {
    local file=/usr/lib/endeavouros-release
    if [ -r $file ] ; then
        cat $file
    else
        echo "Sorry, installer ISO info is not available." >&2
    fi
}


alias ll='ls -lav --ignore=..'   # show long listing of all except ".."
# alias l='ls -lav --ignore=.?*'   # show long listing but no hidden dotfiles except "."
alias l='ls -lav --ignore=.?*'   # show long listing but no hidden dotfiles except "."
alias grep='grep --color=auto'

[[ "$(whoami)" = "root" ]] && return

[[ -z "$FUNCNEST" ]] && export FUNCNEST=100          # limits recursive functions, see 'man bash'

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

    if [ -z "$CheckArchNewsForYou" ] && [ -r $conf ] ; then
        source $conf
    fi

    if [ "$CheckArchNewsForYou" = "yes" ] ; then
        local news="$(yay -Pw)"
        if [ -n "$news" ] ; then
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
    if [ -n "$updates" ] ; then
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
    if [ -x /usr/bin/yay ] ; then
        updates="$(yay -Qua)"
        if [ -n "$updates" ] ; then
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


_open_files_for_editing() {
    # Open any given document file(s) for editing (or just viewing).
    # Note1: Do not use for executable files!
    # Note2: uses mime bindings, so you may need to use
    #        e.g. a file manager to make some file bindings.

    if [ -x /usr/bin/exo-open ] ; then
        echo "exo-open $*" >&2
        /usr/bin/exo-open "$@" >& /dev/null &
        return
    fi
    if [ -x /usr/bin/xdg-open ] ; then
        for file in "$@" ; do
            echo "xdg-open $file" >&2
            /usr/bin/xdg-open "$file" >& /dev/null &
        done
        return
    fi

    echo "Sorry, none of programs [$progs] is found." >&2
    echo "Tip: install one of packages" >&2
    for prog in $progs ; do
        echo "    $(pacman -Qqo "$prog")" >&2
    done
}

_Pacdiff() {
    local differ pacdiff=/usr/bin/pacdiff

    if [ -n "$(echo q | DIFFPROG=diff $pacdiff)" ] ; then
        for differ in kdiff3 meld diffuse ; do
            if [ -x /usr/bin/$differ ] ; then
                DIFFPROG=$differ su-c_wrapper $pacdiff
                break
            fi
        done
    fi
}

#------------------------------------------------------------

## Aliases for the functions above.
## Uncomment an alias if you want to use it.
##

# alias ef='_open_files_for_editing'     # 'ef' opens given file(s) for editing
# alias pacdiff=_Pacdiff
################################################################################


# My bash customisations!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

PS1="\[\e[31m\]\W\[\033[32m\] \$: " # colors for bash info at the beginning
shopt -s autocd # Allows you to cd into a directory by just entering it's name

gc(){
 gcc "$1" -o ~/temp/c_output && ~/temp/c_output
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"

set -o vi   #vi mode in bash 
bind -x '"\C-l": clear;'

# note that these exports will be considered only when loading bash shell. If you want to add or change exports to reflect in i3 dmenu or something, add them in ~/.profile
export ANDROID_HOME=/home/aldrin/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
# export REACT_EDITOR=vscode
export REACT_EDITOR=vscodium
export HISTFILESIZE=1000

xevf(){
 xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
}

# tabtab source for packages
# uninstall by removing these lines
#[ -f ~/.config/tabtab/__tabtab.bash ] && . ~/.config/tabtab/__tabtab.bash || true

# heroku autocomplete setup
HEROKU_AC_BASH_SETUP_PATH=/home/aldrin/.cache/heroku/autocomplete/bash_setup && test -f $HEROKU_AC_BASH_SETUP_PATH && source $HEROKU_AC_BASH_SETUP_PATH;

export NNN_BMS='c:~/Code;d:~/Desktop;g:~/Clg Stuff'
export NNN_USE_EDITOR=1
export NNN_DE_FILE_MANAGER=thunar
export NNN_PLUG='f:finder;d:-drag.sh;x:!chmod +x;g:!git log;w:-wall.sh'
#export NEXT_TELEMETRY_DISABLED=1

#alias ls='ls --color=auto -F'
alias l='ls --color=auto -F'
alias t="tldr"
alias ns="npm start"
alias nd="npm run dev"
alias na="npm run android"
alias p="sudo pacman"
alias ashare='/home/aldrin/personal/scripts/pashare.sh start'
alias bashrc='vim ~/.bashrc'
alias vimrc='vim ~/.vimrc'
#alias scpy='scrcpy -S -w'
#alias scim='sc-im'
alias bluetooth='sudo systemctl start bluetooth && blueman-manager'
alias ccat='highlight -O ansi --force'  # alternative to cat with highlight
alias ec2='ssh -i ~/personal/simpleMusicServer.pem ubuntu@ec2-13-127-207-244.ap-south-1.compute.amazonaws.com'
alias ggpush='git push'
alias ggpull='git pull'
alias n='nnn -e'
alias code='vscodium'
alias r='ranger'
alias v='vim'
alias s='cd ~/.scripts && l'
alias cl='nnn -e ~/clg-stuff'
alias i3config='vim ~/.config/i3/config'
alias glog='git log'
alias gs='git status'
alias co='cd ~/Code && l'
export c="~/Code && l"
alias startdocker='sudo systemctl start docker.service'
alias z='zathura'
alias sx='sxiv'
alias kpr='kjv Proverbs:'
alias hs='firefox --new-tab http://localhost:1313/ & hugo server -D'

~/.scripts/biblequote.sh
#~/.scripts/meaningDict.sh
