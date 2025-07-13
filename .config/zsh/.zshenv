# XDG paths
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}
export XDG_STATE_HOME=${XDG_STATE_HOME:="$HOME/.local/state"}

# Path fix
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export MYVIMRC="$XDG_CONFIG_HOME/vim"

# Custom paths
export HISTFILE="$XDG_DATA_HOME/zsh/history"
export FZFHISTFILE="$XDG_DATA_HOME/fzf/history"
export LESSHISTFILE=- # disable history file.
export ZPLUGINS="$XDG_DATA_HOME/zsh/plugins"
export GEODE_SDK="$XDG_DATA_HOME/Geode/sdk"

# dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# PATH modification

# Append "$1" to $PATH when not already in.
AppendPath() {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

Scripts="$HOME/.local/repos/scripts"

AppendPath "$HOME/.bun/bin"
AppendPath "$HOME/.cabal/bin"
AppendPath "$HOME/.cargo/bin"
AppendPath "$HOME/.dotnet/tools"
AppendPath "$HOME/.ghcup/bin"
AppendPath "$HOME/.local/bin"
AppendPath "$Scripts"

while read -r; do
    AppendPath "$REPLY"
done <<<$(fd -td . "$Scripts" -x echo)

# Force PATH to be in the environment
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
export MANPAGER="nvim +Man!"
