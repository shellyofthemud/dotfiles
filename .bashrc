# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# setting some pretty colors for the terminal
[[ -e $HOME/.cache/wal/sequences ]] && (cat ~/.cache/wal/sequences &)
[[ $(command -v transset-df) ]] && transset-df .85 -a > /dev/null

# set personal environment variables
[ -f ~/.secrets ] && source ~/.secrets

# Aliases
alias q='exit'
alias ls='ls --color=auto'
alias ll='ls -al'
alias deorphan='pacaur -Rsn $(pacaur -Qtdq)'
alias logcat='while true; do dmesg | tail; done'

# Environment variables
export PS1="[\u@\h \W]"
export EDITOR=emacs
export GOPATH=$HOME/go/
export PATH=$PATH:$HOME/bin/:$HOME/go/bin/:$HOME/.gem/ruby/*.*.*/bin:/usr/share/applications/:$HOME/.local/bin/
export PIPENV_VENV_IN_PROJECT="enabled"


# Utility functions
# usage: dockerClean container|image|network|volume [-f]
dockerClean() {
	docker $1 rm $(docker $1 ls --format "{{.ID}}") $2
}

# usage: echo $PATH (or other colon-separated string) | splitpath
splitpath() {
    str=$(cat)
    IFS=':'
    read -ra ADDR <<< "$str"
    for i in "${ADDR[@]}"; do
	echo $i
    done
    IFS=' '
}

# usage: takes no args, does not change directory
# dfupdate() {
	# [[ ! -e ~/.git ]] && [[ ~ -e ~/git/ ]] && mkdir ~/git; git clone git@github.com:sarenord/dotfiles ~/git/ && source $HOME/git/dotfiles/install.sh
# }

# End section - these are just things that you're not supposed to put anywhere but the end
# start xorg
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	exec startx
fi

# set thefuck aliases
eval $(thefuck --alias)
