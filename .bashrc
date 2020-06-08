# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# setting some pretty colors for the terminal
[[ -e $HOME/.cache/wal/sequences ]] && (cat ~/.cache/wal/sequences &)
[[ $(command -v transset-df) ]] && transset-df .85 -a > /dev/null

# set up completion awareness for docker-machine
source /etc/bash_completion.d/docker-machine-prompt.bash

# set personal environment variables
[ -f ~/.secrets ] && source ~/.secrets

# Aliases
alias q='exit'
alias ls='ls --color=auto'
alias ll='ls -al'
alias deorphan='yay -Rsn $(yay -Qtdq)'
alias logcat='while true; do dmesg | tail; done'

# Environment variables
export EDITOR=emacs
export GOPATH=$HOME/go/
export PATH=$PATH:$HOME/bin/:$HOME/go/bin/:$HOME/.gem/ruby/*.*.*/bin:/usr/share/applications/:$HOME/.local/bin/
export PIPENV_VENV_IN_PROJECT="enabled"


# Utility functions
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

dockerprompt() {
	location=$(__docker_machine_ps1)
	if [ -z "$location" ]; then
		location='local'
	fi
}

# Prompt settings
HOST='\e[92m\u@\h\e[39m'
PROMPT='\W \$> '
BRANCH='$(git branch --show-current --color=always)'
REPO='$(git config --get remote.origin.url | splitpath | tail -n 1)'
DOCKER='$(__docker_machine_ps1 "%s" | awk '\''{ print } END { if (!NR) print "local" }'\'' )'
GIT="${REPO}-${BRANCH}"
WHERE="[\e[36m${DOCKER} \e[31m${GIT}\e[39m]\e[49m"
export PS1="${HOST} ${WHERE}\n${PROMPT}"

# set thefuck aliases
eval $(thefuck --alias)
