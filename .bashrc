# If not running interactively, don't do anything
[[ $- != *i* ]] && return
(cat ~/.cache/wal/sequences &)

# Aliases
alias q='exit'
alias ls='ls --color=auto'
alias ll='ls -al'
alias deorphan='pacaur -Rsn $(pacaur -Qtdq)'
alias logcheck='while true; do dmesg | tail; done'
PS1="[\u@\h \W]"
transset-df .85 -a > /dev/null
export EDITOR=emacs
export GOPATH=/home/sarenord/go/
export PATH=$PATH:/home/sarenord/bin/:/home/sarenord/go/bin/:$HOME/.gem/ruby/2.4.0/bin:/usr/lib/emscripten/:/usr/share/applications/:/home/sarenord/.local/bin/


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

# start xorg
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	exec startx
fi

# set thefuck aliases
eval $(thefuck --alias)
