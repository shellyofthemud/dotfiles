#!/bin/bash

mkdir -p $HOME/.config/bash_completion.d

wget https://raw.githubusercontent.com/docker/machine/master/contrib/completion/bash/docker-machine-prompt.bash -O $HOME/.config/bash_completion.d/docker-machine-prompt.bash
wget https://raw.githubusercontent.com/docker/machine/master/contrib/completion/bash/docker-machine-wrapper.bash -O $HOME/.config/bash_completion.d/docker-machine-wrapper.bash
wget https://raw.githubusercontent.com/docker/machine/master/contrib/completion/bash/docker-machine.bash -O $HOME/.config/bash_completion.d/docker-machine.bash
