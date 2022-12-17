alias q='exit'
alias ls='ls --color=auto'
alias ll='ls -al'
alias pmdo='yay -Rsn $(yay -Qtdq)'
alias logcat='while true; do dmesg | tail; done'
alias ippub='`curl -s api.ipify.org`'
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/.git --work-tree=$HOME/dotfiles'

[ -d $HOME/.config/bash_completion.d ] && for f in $HOME/.config/bash_completion.d/*; do source $f; done

getGitUpstream() {
    repo=$(git config --get remote.origin.url)
    read -r -a repoAR <<< "${repo//\// }"
    echo ${repoAR[-1]}/${repoAR[-2]}
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