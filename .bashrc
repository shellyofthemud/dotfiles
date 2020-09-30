# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# setting some pretty colors for the terminal
[[ -e $HOME/.cache/wal/sequences ]] && (cat ~/.cache/wal/sequences &)
[[ $(command -v transset-df) ]] && transset-df .85 -a > /dev/null

# set up completion awareness for docker-machine
source /etc/bash_completion.d/docker-machine-prompt.bash

# set personal environment variables
[ -f ~/.secrets ] && source ~/.secrets

[ -f $HOME/.bash_aliases ] && source $HOME/.bash_aliases

export PIPENV_VENV_IN_PROJECT="enabled"

# Prompt settings
HOST='\e[92m\u@\h\e[39m'
PROMPT='\W \$> '
BRANCH='-$(git branch --show-current --color=always)'
DOCKER='$(__docker_machine_ps1 "%s" | awk '\''{ print } END { if (!NR) print "local" }'\'' )'
REPO=$(getGitUpstream)
GIT="${REPO}${BRANCH}"
WHERE="[\e[36m${DOCKER} \e[31m${GIT}\e[39m]\e[49m"
export PS1="${HOST} ${WHERE}\n${PROMPT}"

# set thefuck aliases
eval $(thefuck --alias)
