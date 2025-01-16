[[ "$(tty)" = "/dev/tty1" ]] && pgrep $WWM

if [[ "$(tty)" = "/dev/tty2" ]]; then
    pgrep $XWM || sx "$XDG_CONFIG_HOME/X11/xinitrc"
fi
