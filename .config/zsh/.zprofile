if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep $WM || sx "$XDG_CONFIG_HOME/X11/xinitrc"
fi
