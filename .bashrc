# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PIPENV_VENV_IN_PROJECTS=true
export XDG_DATA_HOME=$HOME/.local/share
force_color_prompt=yes
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

if [ -n "$force_color_prompt" ]; then
	color_prompt=yes
else
	color_prompt=
fi

# set up completion scripts
if ! -d $HOME/.config/bash_completion.d; then
	source $HOME/bin/docker-machine-ps1.sh	
fi

# setting some pretty colors for the terminal
[[ -e $HOME/.cache/wal/sequences ]] && (cat ~/.cache/wal/sequences &)
[[ $(command -v transset-df) ]] && transset-df .85 -a > /dev/null

# set personal environment variables
[ -f ~/.secrets ] && source ~/.secrets

# Bash completion if available
[ -f $HOME/.bash_aliases ] && source $HOME/.bash_aliases
if [[ $PS1 && $(! shopt -oq posix) ]]; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		source /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		source /etc/bash_completion
	fi
fi

# Prompt settings
# WHERE="[\e[36m${DOCKER} \e[31m${GIT}\e[39m]\e[49m"
export PS1="$(build_ps1) "

# set thefuck aliases
eval $(thefuck --alias)
