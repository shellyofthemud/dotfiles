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

dockerprompt() {
	location=$(__docker_machine_ps1)
	if [ -z "$location" ]; then
		location='local'
	fi
}