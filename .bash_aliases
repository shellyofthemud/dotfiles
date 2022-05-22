alias q='exit'
alias ls='ls --color=auto'
alias ll='ls -al'
alias pmdo='yay -Rsn $(yay -Qtdq)'
alias logcat='while true; do dmesg | tail; done'
alias ippub='`curl -s api.ipify.org`'

# usage: echo $PATH (or other colon-separated string) | splitpath

getGitUpstream() {
    repo=$(git config --get remote.origin.url)
    read -r -a repoAR <<< "${repo//\// }"
    echo ${repoAR[-1]}/${repoAR[-2]}
}


splitpath() {
    str=$(cat)
    IFS=':'
    read -ra ADDR <<< "$str"
    for i in "${ADDR[@]}"; do
	echo $i
    done
    IFS=' '
}

docker_machine_ps1() {
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

build_ps1() {
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

update-dotfiles() {
	$wd=$(pwd)
	cd /tmp
	git clone http://github.com/shell-drick/dotfiles
	cd dotfiles
	git submodule update --init --recursive
	rm -rf .git .gitmodules
	cp -r bin $HOME/
	cp -r ./.* $HOME/
	cd ..; rm -rf dotfiles
	cd $wd
}
