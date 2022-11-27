# if [ -f ~/.bashrc ]; then
#     . ~/.bashrc
# fi
export TERMINFO=/usr/share/terminfo
export PATH=$PATH:/home/aldrin/.scripts
export PATH=$PATH:/home/aldrin/.scripts/da
export PATH=$PATH:/home/aldrin/.scripts/phonesync
export PATH=$PATH:/home/aldrin/.scripts/polybar-scripts/
# export PATH=$PATH:/home/aldrin/.local/bin/
# export PATH=$PATH:/usr/local/bin/
# setleds -D +num
numlockx on
# setxkbmap -layout us -variant ,qwerty # set keyboard layout, but doesn't work in tty :(
loadkeys us # same as above, but works on tty as well
# setxkbmap -option caps:escape
# swapcaps.sh # mapping capslock to escape
