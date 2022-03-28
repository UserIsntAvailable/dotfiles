
# If not running interactively, don't do anything
[[ $- != *i* ]] && return


### Z Config ###
HISTSIZE=1000
SAVEHIST=1000

autoload -U colors && colors
autoload -U compinit && compinit -u

setopt share_history

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zmodload zsh/complist
compinit
_comp_options+=(globdots)


### Source ###
source "$ZDOTDIR/.zfuncs"
source "$ZDOTDIR/.zprompt"
source "$ZDOTDIR/.zaliases"
source "$ZPLUGINS/git-prompt/git-prompt.plugin.zsh"
source "$ZPLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 2>/dev/null
