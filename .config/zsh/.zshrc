# If not running interactively, don't do anything
[[ $- != *i* ]] && return

### Z Config ###

# Share history between shells and remove duplicate entries
setopt BANG_HIST
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS

HISTSIZE=10000
SAVEHIST=10000

autoload -U colors && colors
autoload -U compinit && compinit -u

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zmodload zsh/complist
compinit
_comp_options+=(globdots)

read -r -d '\0' TIMEFMT << EOF
---------------
 CPU    | %P
 User   | %*U
 System | %*S
 Total  | %*E
EOF

### Source ###

source "$ZDOTDIR/.zprompt"
source "$ZDOTDIR/.zaliases"
source "$ZDOTDIR/.zkeybinds"

### Plugins ###

# Git Prompt
source "$ZPLUGINS/git-prompt/plugins/git-prompt/git-prompt.plugin.zsh"

ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[white]%}"

# Autosuggestions
source "$ZPLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Syntax Highlight
source "$ZPLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=blue,underline
ZSH_HIGHLIGHT_STYLES[precommand]=fg=blue,underline
ZSH_HIGHLIGHT_STYLES[arg0]=fg=blue

### Completions ###

[[ -s "/home/dots/.bun/_bun" ]] && source "/home/dots/.bun/_bun"
