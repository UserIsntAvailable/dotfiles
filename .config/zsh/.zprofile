if [[ "$(tty)" = "/dev/tty1" ]]; then
    niri-session -l
fi

if [[ "$(tty)" = "/dev/tty2" ]]; then
    pgrep awesome || sx "$XDG_CONFIG_HOME/X11/xinitrc"
fi
