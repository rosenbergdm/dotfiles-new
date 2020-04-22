#!/usr/local/bin/sh

. "$HOME/.bashrc"
xset -b b off
xset b 0 0 0
xrdb -m ~/.Xdefaults
# xsetroot -solid dark
# xsetroot -cursor_name left_ptr
# xsetroot general
# xset fp rehash

eval "`ssh-agent`"
ssh-agent quartz-wm --only-proxy
export RXVT_SOCKET=$HOME/.rxvt_socket

urxvtd --quiet --opendisplay --fork

quartz-wm &
/usr/local/bin/urxvtc


while true
do
  xsetroot -name "`date +"%H:%M"`"
  xset r rate 250 30
  xset b off
  sleep 5
done &




# vim: ft=sh

