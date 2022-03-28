if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep awesome || sx "$XDG_CONFIG_HOME/X11/xinitrc"
fi
