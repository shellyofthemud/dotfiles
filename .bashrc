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

function docker_machine_ps1() {
    local format=${1:- [%s]}
    if test ${DOCKER_MACHINE_NAME}; then
        local status
        if test ${DOCKER_MACHINE_PS1_SHOWSTATUS:-false} = true; then
            status=$(docker-machine status ${DOCKER_MACHINE_NAME})
            case ${status} in
                Running)
                    status=' R'
                    ;;
                Stopping)
                    status=' R->S'
                    ;;
                Starting)
                    status=' S->R'
                    ;;
                Error|Timeout)
                    status=' E'
                    ;;
                *)
                    # Just consider everything elase as 'stopped'
                    status=' S'
                    ;;
            esac
        fi
        printf -- "${format}" "${DOCKER_MACHINE_NAME}${status}"
    fi

}

function build_ps1() {
	locationline=true
	gitbranch=false
	dockermachine=true
	workdir=true
	fullworkdir=true
	
	_hostname='\e[92m\u@\h\e[39m'
	_prompt='\$>'
	_workdir='\W'
	_fullworkdir='\e[35m\w\e[39m'
	_gitbranch='-$(git branch --show-current --color=always)'
	_dockermachine='$(__docker_machine_ps1 "%s" | awk '\''{ print } END { if (!NR) print "local" }'\'' )'
	_newline='\n'
	
	_ps1fmt="${_hostname}"

	if $fullworkdir; then
		_ps1fmt="$_ps1fmt $_fullworkdir"
	fi

	if $dockermachine; then
		_ps1fmt="$_ps1fmt \e[36m$_dockermachine\e[39m"
	fi
	
	if $locationline; then
		_ps1fmt=$_ps1fmt$_newline
	fi
	
	if $workdir; then
		_ps1fmt=$_ps1fmt$_workdir
	fi
	
	_ps1fmt="$_ps1fmt $_prompt"
	
	echo $_ps1fmt
}

# Prompt settings
# WHERE="[\e[36m${DOCKER} \e[31m${GIT}\e[39m]\e[49m"
export PS1="$(build_ps1) "

# set thefuck aliases
eval $(thefuck --alias)
