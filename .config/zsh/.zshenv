# XDG paths
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}

# Path fix
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export XSERVERRC="$XDG_CONFIG_HOME"/X11/xserverrc
export XAUTHORITY="$XDG_RUNTIME_DIR/"Xauthority
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export FFMPEG_DATADIR="$XDG_CONFIG_HOME"/ffmpeg
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GOPATH="$XDG_DATA_HOME"/go
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export WINEPREFIX="$XDG_DATA_HOME"/wineprefixes/default
export NUGET_PACKAGES="$XDG_CACHE_HOME"/NuGetPackages
export HISTFILE="$XDG_DATA_HOME"/zsh/history
export MYVIMRC="$XDG_CONFIG_HOME/vim"

# dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Custom paths
export HISTFILE="$XDG_DATA_HOME/zsh/history"
export FZFHISTFILE="$XDG_DATA_HOME/fzf/history"
export LESSHISTFILE=- # disable history file.
export ZPLUGINS="$XDG_DATA_HOME/zsh/plugins"

# PATH modification
typeset -U path PATH

scripts="$HOME/.local/repos/scripts"
path=("$HOME/.dotnet/tools" "$CARGO_HOME/bin" "$scripts" $(fd -td . "$scripts" -X echo) $path)

export PATH

# Default Apps
export EDITOR="nvim"
export VISUAL="nvim"
export TERM="wezterm"
export TERMINAL="wezterm"
export BROWSER="firefox"
export VIDEO="mpv"
export IMAGE="sxiv"
export OPENER="xdg-open"
export PAGER="less"
export WM="awesome"
