if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting

### Aliases ###

# ls
alias ls "ls -lah --color=auto"

# mkdir
alias mkdir "mkdir -pv"

# confirmations
alias mv "mv -i"
alias cp "cp -i"
alias rm "rm -i"
alias ln "ln -i"

# vscodium
alias code "vscodium"

# dotfiles bare repo config
alias dotfiles "/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME"
