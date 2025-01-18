if [[ "$(tty)" = "/dev/tty1" ]]; then
    pgrep $WWM || exec $WWM
fi

if [[ "$(tty)" = "/dev/tty2" ]]; then
    pgrep $XWM || sx "$XDG_CONFIG_HOME/X11/xinitrc"
fi
